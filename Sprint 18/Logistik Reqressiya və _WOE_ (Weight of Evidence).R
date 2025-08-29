library(tidyverse)
library(rstudioapi)
library(car)
library(inspectdf)
library(MLmetrics)
library(scorecard)
library(glue)
library(highcharter)
library(pROC)

path <- dirname(getSourceEditorContext()$path)
setwd(path)

data <- read_csv("churn.csv")


# Datanın Önhazırlığı - Data Preprocessing ----
data %>% glimpse()


data$y <- data$y %>%
  recode("'yes' = 1; 'no' = 0") %>%
  as_factor()

data$y %>% table() %>% prop.table() %>% round(2)


data %>% inspect_na()


target <- "y"
exclude <- c("id")


# "Weight Of Evidence" ----

# IV (information values) 
iv <- data %>% 
  select(-all_of(exclude)) %>% 
  iv(y = target) %>% 
  as_tibble() %>%
  mutate(info_value = round(info_value, 3)) %>%
  arrange(desc(info_value))

# IV dəyəri 0.02'dən kiçik olan dəyişənləri çıxarmaq
ivars <- iv %>% 
  filter(info_value > 0.02) %>% 
  pull(variable) 

df.iv <- data %>% select(all_of(target),all_of(ivars))

df.iv %>% dim()

# Datanın bölünməsi
dt_list <- df.iv %>% 
  split_df(target, ratio = 0.8, seed = 123)

# woe binning 
bins <- dt_list$train %>% woebin(target)

bins$age %>% as_tibble()
bins$age %>% woebin_plot()
bins$marital %>% as_tibble()
bins$marital %>% woebin_plot()
bins$job %>% as_tibble()
bins$job %>% woebin_plot()

train_woe <- dt_list$train %>% woebin_ply(bins) 
test_woe <- dt_list$test %>% woebin_ply(bins)

names <- train_woe %>% 
  names() %>% 
  str_replace_all("_woe","")  

names(train_woe) <- names
names(test_woe) <- names


# "Multicollinearity" probleminin həll olunması ----
features <- train_woe %>% select(-all_of(target)) %>% names()

vif_values <- sapply(features, function(target) {
  formula <- as.formula(paste(target, "~ ."))
  model <- lm(formula, data = train_woe %>% select(all_of(features)))
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
    model <- lm(formula, data = train_woe %>% select(all_of(features)))
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


# GLM (Generalized Linear Model) alqoritmasının qurulması - Fitting GLM (Generalized Linear Model) algorithm ----
train <- train_woe %>% select(all_of(target),all_of(features))
test <- test_woe %>% select(all_of(target),all_of(features))

f <- as.formula(paste(target, paste(features, collapse = " + "), sep = " ~ "))
glm <- glm(f, data = train, family = "binomial")


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


# Addım-addım geriyə doğru aradan qaldırılma - Stepwise Backward Elimination
while(p_values[1,"p_value"] >= 0.05) {
  p_value_worst <- p_values[1,] 
  print(p_value_worst)
  
  features <- features[features != p_value_worst$names]
  
  # refit
  f <- as.formula(paste(target, paste(features, collapse = " + "), sep = " ~ "))
  glm <- glm(f, data = train, family = "binomial")
  
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
    p_value = round(`Pr(>|z|)`, 3)
  )


# Proqnozlar ----
pred_prob <- glm %>% 
  predict(newdata = test, type = "response")


# Optimal "Threshold" tapılması ----
actual <- test %>% 
  pull(all_of(target))

results <- data.frame(
  pred_prob = pred_prob, 
  actual = actual) %>% 
  mutate(pred_prob = round(pred_prob,4))

thresholds <- seq(0, 1, 0.01)

f1_scores <- sapply(thresholds, function(thr) {
  preds_class <- ifelse(pred_prob > thr, 1, 0)
  F1_Score(y_pred = preds_class, y_true = actual)
})

thresholds_df <- data.frame(
  thresholds = thresholds, 
  f1_scores = f1_scores) 

max_f1 <- thresholds_df$f1_scores %>% max(na.rm = T)

opt_thresh <- thresholds_df %>% 
  filter(f1_scores == max_f1) %>% 
  pull(thresholds)

pred_class <- if_else(pred_prob > opt_thresh,"1","0")


# Klassifikasiya Modelinin Perormansının Qiymətləndirilməsi ----

# Qarışıqlıq matrisi - Confision Matrix

actual %>% table()
pred_class %>% table()

cm <- table(actual,pred_class)

df <- cm %>% 
  as.data.frame() %>%
  mutate(
    x = as.numeric(as.character(pred_class)),  
    y = as.numeric(as.character(actual)),   
    value = Freq
  )

highchart() %>%
  hc_chart(type = "heatmap") %>%
  hc_xAxis(categories = levels(df$pred_class), title = list(text = "Predicted")) %>%
  hc_yAxis(categories = levels(df$actual), title = list(text = "Actual")) %>%
  hc_add_series(
    name  = "Count",
    type  = "heatmap",
    data  = list_parse(df[, c("x","y","value")]),
    dataLabels = list(enabled = T)
  ) %>%
  hc_colorAxis(min = 0) %>%
  hc_title(text = "Confusion Matrix")

tp <- cm[2,2]
tn <- cm[1,1]
fp <- cm[1,2]
fn <- cm[2,1]

accuracy <- (tp + tn) / (tp + tn + fp + fn)
precision <- tp / (tp + fp)
recall_sensitivity <- tp / (tp + fn)
specifity <- tn / (tn + fn)
f1_score <- 2 * precision * recall_sensitivity / (precision + recall_sensitivity)
balanced_accuracy <- (recall_sensitivity + specifity) / 2

tibble(precision,recall_sensitivity,specifity,
       accuracy,f1_score,balanced_accuracy)


# Area Under Curve (AUC) və ROC əyrisi

roc_points <- sapply(thresholds, function(t) {
  pred_class <- ifelse(pred_prob > t, 1, 0)
  
  TP <- sum(pred_class == 1 & actual == 1)
  FP <- sum(pred_class == 1 & actual == 0)
  TN <- sum(pred_class == 0 & actual == 0)
  FN <- sum(pred_class == 0 & actual == 1)
  
  TPR <- TP / (TP + FN)   # sensitivity, recall
  FPR <- FP / (FP + TN)   # 1 - specificity
  
  c(FPR, TPR)
})

roc_df <- data.frame(
  threshold = thresholds,
  fpr = roc_points[1, ],
  tpr = roc_points[2, ]
)

auc <- sum(diff(roc_df$fpr) * (head(roc_df$tpr, -1) + tail(roc_df$tpr, -1)) / 2) %>% 
  abs() %>% 
  round(2)

roc_df %>% 
  hchart("line", hcaes(x = fpr, y = tpr)) %>%
  hc_title(text = "ROC Curve") %>%
  hc_xAxis(title = list(text = "False Positive Rate (1 - Specificity)")) %>%
  hc_yAxis(title = list(text = "True Positive Rate (Sensitivity)")) %>%
  hc_add_annotation(
    labels = list(
      point = list(xAxis=0,yAxis=0,x=0.3,y=0.6),
      text = glue('AUC = {enexpr(auc)}'))
  ) %>%
  hc_tooltip(pointFormat = "FPR: {point.x:.2f} <br>TPR: {point.y:.2f}") %>%
  hc_title(text = "ROC əyrisi") 


# "Overfitting" / "Underfitting" ----
pred_prob_train <- glm %>% 
  predict(newdata = train, type = "response")

actual_train <- train %>% 
  pull(all_of(target))

results_train <- data.frame(
  pred_prob = pred_prob_train, 
  actual = actual_train) %>% 
  mutate(pred_prob = round(pred_prob,4))

thresholds <- seq(0, 1, 0.01)

f1_scores_train <- sapply(thresholds, function(thr) {
  preds_class <- ifelse(pred_prob_train > thr, 1, 0)
  F1_Score(y_pred = preds_class, y_true = actual_train)
})

thresholds_df <- data.frame(
  thresholds = thresholds, 
  f1_scores = f1_scores) 

max_f1 <- thresholds_df$f1_scores %>% max(na.rm = T)

opt_thresh <- thresholds_df %>% 
  filter(f1_scores == max_f1) %>% 
  pull(thresholds)

pred_class_train <- if_else(pred_prob_train > opt_thresh,"1","0")

# Müqayisə
roc_obj_train <- roc(as.numeric(as.character(actual_train)), as.numeric(pred_prob_train))
auc_train <- auc(roc_obj_train) %>% 
  round(2)

roc_obj_test <- roc(as.numeric(as.character(actual)), as.numeric(pred_prob))
auc_test <- auc(roc_obj_test) %>% 
  round(2)

tibble(auc_train, auc_test)
