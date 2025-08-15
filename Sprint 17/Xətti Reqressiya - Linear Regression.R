library(tidyverse) 
library(inspectdf)
library(recipes)
library(mice)
library(graphics)
library(Metrics)
library(plotly)
library(glue)
library(patchwork)

data <- dslabs::gapminder


# Datanın təmizlənməsi - Data Cleaning ----
data %>% glimpse()

data <- data %>% 
  mutate(year = as_factor(year))

data %>% inspect_na()

data %>% 
  inspect_na() %>% 
  filter(pcnt < 60) %>% 
  pull(col_name) -> variables

data <- data %>% select(all_of(variables))


target <- "life_expectancy"


df.num <- data %>%
  select_if(is.numeric) %>% 
  select(all_of(target),everything())

df.chr <- data %>%
  mutate_if(is.character,as.factor) %>% 
  select_if(is.factor)


# Numeric dəyişənlərin təmizlənməsi
df.num %>% inspect_na()

df.num <- df.num %>% 
  mice(method = "rf", seed = 123) %>% 
  complete()


# Character dəyişənlərin təmizlənməsi
df.chr %>% inspect_na()

df.chr <- df.chr %>% 
  recipe(~ .) %>%
  step_impute_mode(all_nominal()) %>%
  prep() %>% 
  bake(df.chr)


# Kəmiyyət dəyişənlərdə Outlier'ların həll olunması ----
solve_outliers <- function(data, target) {
  num_vars <- data %>% 
    select(-all_of(target)) %>% 
    names()
  
  for_vars <- c()
  for (b in 1:length(num_vars)) {
    OutVals <- boxplot(data[[num_vars[b]]], plot=F)$out
    if(length(OutVals)>0){
      for_vars[b] <- num_vars[b]
    }
  }
  for_vars <- for_vars %>% as.data.frame() %>% drop_na() %>% pull(.)
  for_vars %>% length()
  
  for (o in for_vars) {
    OutVals <- boxplot(data[[o]], plot=F)$out
    mean <- mean(data[[o]],na.rm=T)
    
    o3 <- OutVals[OutVals > mean]
    o1 <- OutVals[OutVals < mean]
    
    val3 <- quantile(data[[o]], 0.75, na.rm = T) + 1.5 * IQR(data[[o]], na.rm = T)
    data[which(data[[o]] %in% o3),o] <- val3
    
    val1 <- quantile(data[[o]], 0.25, na.rm = T) - 1.5*IQR(data[[o]], na.rm = T)
    data[which(data[[o]] %in% o1),o] <- val1
  }
  return(data)
}

df.num <- df.num %>% solve_outliers(target = target)


# Keyfiyyət dəyişənlər üçün "One Hote Encoding" ----
df.chr <- df.chr %>%
  recipe(~ .) %>%
  step_dummy(all_nominal_predictors()) %>%
  prep() %>%
  bake(df.chr)


df <- cbind(df.num,df.chr) %>%
  select(all_of(target),everything())


# "Multicollinearity" probleminin həll olunması və VIF (Variance Inflation Factor) ----
features <- df %>% select(-all_of(target)) %>% names()

vif_values <- sapply(features, function(target) {
  formula <- as.formula(paste(target, "~ ."))
  model <- lm(formula, data = df[, features])
  1 / (1 - summary(model)$r.squared)
})

vif_values <- vif_values[!is.infinite(vif_values)]

vif_values <- vif_values %>% 
  as.data.frame() %>% 
  rownames_to_column() %>% 
  rename(VIF = ".",
         feature = rowname) %>% 
  arrange(desc(VIF))

while (vif_values$VIF %>% .[1] >= 2) {
  features <- vif_values[-1,"feature"]
  
  vif_values <- sapply(features, function(target) {
    formula <- as.formula(paste(target, "~ ."))
    model <- lm(formula, data = df[, features])
    1 / (1 - summary(model)$r.squared)
  })
  
  vif_values <- vif_values %>% 
    as.data.frame() %>% 
    rownames_to_column() %>% 
    rename(VIF = ".",
           feature = rowname) %>% 
    arrange(desc(VIF))
}

features <- vif_values$feature

df <- df %>% select(all_of(target),all_of(features))


# Standartlaşdırma / Normallaşdırma ----
df %>% glimpse()

df[,-1] <- df[,-1] %>% scale() %>% as.data.frame()


# Datanın bölünməsi - Splitting the data ----
set.seed(123)

sample <- sample(1:nrow(df), 0.8*nrow(df))
train <- df[sample, ]
test  <- df[-sample, ]


# GLM (Generalized Linear Model) alqoritmasının qurulması ----
f <- as.formula(paste(target, paste(features, collapse = " + "), sep = " ~ "))
glm <- glm(f, data = train)


# Proqnozlaşdırıcıların əhəmiyyət səviyyələri - Significance levels of predictors ----
coef_tab <- as.data.frame(summary(glm)$coefficients)
coef_tab <- coef_tab %>% 
  rownames_to_column(var = "names")
names(coef_tab) <- c("names","estimate","std_error","t_value","p_value")

p_values <- coef_tab %>%
  select(names, p_value) %>%
  mutate(p_value = round(p_value, 3)) %>%
  filter(names != "(Intercept)") %>%
  arrange(desc(p_value))

# P dəyərinin əhəmiyyət səviyyələri - Significance levels of P_value:
# 0    <= p_val < 0.001 ***
# 0.001 < p_val < 0.05  **
# 0.05  < p_val < 0.01  *
# 0.01  < p_val < 0.1   .

# Addım-addım geriyə doğru aradan qaldırılma - Stepwise Backward Elimination
while(p_values[1,"p_value"] >= 0.05) {
  p_value_worst <- p_values[1,] 
  print(p_value_worst)
  
  features <- features[features != p_value_worst$names]
  
  # refit
  f <- as.formula(paste(target, paste(features, collapse = " + "), sep = " ~ "))
  glm <- glm(f, data = train)
  
  coef_tab <- as.data.frame(summary(glm)$coefficients)
  coef_tab <- coef_tab %>% 
    rownames_to_column(var = "names")
  names(coef_tab) <- c("names","estimate","std_error","t_value","p_value")
  
  p_values <- coef_tab %>%
    select(names, p_value) %>%
    mutate(p_value = round(p_value, 3)) %>%
    filter(names != "(Intercept)") %>%
    arrange(desc(p_value))
}

summary(glm)$coefficients %>% 
  as.data.frame() %>%
  rownames_to_column("names") %>%
  transmute(
    names,
    p_value = round(`Pr(>|t|)`, 3)
  )


# Proqnozlar ----
pred <- glm %>% 
  predict(newdata = test, type = "response")


# Reqressiya Modelinin Perormansının Qiymətləndirilməsi ----
actual <- test %>% 
  pull(all_of(target))

eval_func <- function(x, y) summary(lm(y~x))
eval_sum <- eval_func(actual,pred)

eval_sum$adj.r.squared %>% round(2)
mae(actual,pred) %>% round(1)
rmse(actual,pred) %>% round(1)

# Plot
results <- cbind(pred,actual) %>% 
  as.data.frame()

Adjusted_R2 <- eval_sum$adj.r.squared

g <- results %>% 
  ggplot(aes(pred, actual)) + 
  geom_point(color = "darkred") + 
  geom_smooth(method = lm) + 
  labs(x = "Proqnoz dəyərlər", 
       y = "Əsl dəyərlər",
       title = glue("Test: Adjusted R2 = {round(enexpr(Adjusted_R2),2)}")) +
  theme(plot.title = element_text(color = "darkgreen", size=16, hjust=0.5),
        axis.text.y = element_text(size=12), 
        axis.text.x = element_text(size=12),
        axis.title.x = element_text(size=14), 
        axis.title.y = element_text(size=14))

g %>% ggplotly()


# "Overfitting" / "Underfitting" ----
pred_train <- glm %>% 
  predict(newdata = train, type = "response")

actual_train <- train %>% 
  pull(all_of(target))

eval_sum <- eval_func(actual_train,pred_train)

eval_sum$adj.r.squared %>% round(2)
mae(actual_train,pred_train) %>% round(1)
rmse(actual_train,pred_train) %>% round(1)

# Plot
results_train <- cbind(pred_train,actual_train) %>% 
  as.data.frame()

Adjusted_R2_train <- eval_sum$adj.r.squared

g_train <- results_train %>% 
  ggplot(aes(pred_train, actual_train)) + 
  geom_point(color = "darkred") + 
  geom_smooth(method = lm) + 
  labs(x = "Proqnoz dəyərlər", 
       y = "Əsl dəyərlər",
       title = glue("Train: Adjusted R2 = {round(enexpr(Adjusted_R2_train),2)}")) +
  theme(plot.title = element_text(color="darkgreen", size=16, hjust=0.5),
        axis.text.y = element_text(size=12), 
        axis.text.x = element_text(size=12),
        axis.title.x = element_text(size=14), 
        axis.title.y = element_text(size=14))

g_train %>% ggplotly()

# Müqayisə 
g_train + g

tibble(Adjusted_R2_train,
       Adjusted_R2_test = Adjusted_R2)
