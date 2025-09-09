library(tidyverse)
library(inspectdf)
library(tidymodels)
library(discrim)
library(bonsai)

data <- read_csv("churn.csv")

data %>% glimpse()

data$y <- data$y %>%
  car::recode("'yes' = 1; 'no' = 0") %>%
  as_factor()

data$y %>% table() %>% prop.table() %>% round(2)


data %>% inspect_na()


target <- "y"
exclude <- c("id")


# Datanın bölünməsi - Splitting the data ----
data_split <- data %>% 
  select(-all_of(exclude)) %>% 
  initial_split(prop = 0.8, strata = target)
train <- training(data_split)
test  <- testing(data_split)

# Alqoritmalar ----

form <- as.formula(paste(target, "~ ."))

metrics_cls <- metric_set(accuracy, f_meas, precision, recall)

# GLM — Linear Regression
glm_spec <- logistic_reg(mode = "classification") %>% 
  set_engine("glm")

glm_wf <- workflow() %>% 
  add_model(glm_spec) %>% 
  add_formula(form)

glm_fit <- glm_wf %>% 
  fit(train)

glm_pred <- predict(glm_fit, test, type = "prob") %>%
  bind_cols(predict(glm_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = glm_pred$truth, 
  estimate = as.numeric(as.character(glm_pred$.pred_0))
)

glm_metrics <- glm_pred %>% 
  metrics_cls(truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# KNN 
knn_spec <- nearest_neighbor(
  mode = "classification",
  neighbors = 5,
  weight_func = "rectangular") %>%
  set_engine("kknn")

knn_wf <- workflow() %>% 
  add_model(knn_spec) %>% 
  add_formula(form)

knn_fit <- knn_wf %>% 
  fit(train)

knn_pred <- predict(knn_fit, test, type = "prob") %>%
  bind_cols(predict(knn_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = knn_pred$truth, 
  estimate = as.numeric(as.character(knn_pred$.pred_0))
)

knn_metrics <- knn_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# Naive Bayes
nb_spec <- naive_Bayes(mode = "classification") %>%
  set_engine("naivebayes")  

nb_wf <- workflow() %>% 
  add_model(nb_spec) %>% 
  add_formula(form)

nb_fit <- nb_wf %>% 
  fit(train)

nb_pred <- predict(nb_fit, test, type = "prob") %>%
  bind_cols(predict(nb_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = nb_pred$truth, 
  estimate = as.numeric(as.character(nb_pred$.pred_0))
)

nb_metrics <- nb_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# SVM 
svm_spec <- svm_rbf(mode = "classification") %>%
  set_engine("kernlab")

svm_wf <- workflow() %>% 
  add_model(svm_spec) %>% 
  add_formula(form)

svm_fit <- svm_wf %>% 
  fit(train)

svm_pred <- predict(svm_fit, test, type = "class") %>%
  mutate(truth = test[[target]])

# auc <- roc_auc_vec(
#   truth = svm_pred$truth, 
#   estimate = as.numeric(as.character(svm_pred$.pred_0))
# )

svm_metrics <- svm_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) #%>% 
  # bind_rows(tibble(
  #   .metric = "auc",
  #   .estimate = auc
  # ))

# Decision Tree
tree_spec <- decision_tree(
  mode = "classification",
  tree_depth = 15,
  min_n = 2) %>%
  set_engine("rpart")

tree_wf <- workflow() %>% 
  add_model(tree_spec) %>% 
  add_formula(form)

tree_fit <- tree_wf %>% 
  fit(train)

tree_pred <- predict(tree_fit, test, type = "prob") %>%
  bind_cols(predict(tree_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = tree_pred$truth, 
  estimate = as.numeric(as.character(tree_pred$.pred_0))
)

tree_metrics <- tree_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# Random Forest (Bagging)
rf_spec <- rand_forest(
  mode = "classification",
  trees = 500,
  min_n = 5) %>%
  set_engine("ranger")

rf_wf <- workflow() %>% 
  add_model(rf_spec) %>% 
  add_formula(form)

rf_fit <- rf_wf %>% 
  fit(train)

rf_pred <- predict(rf_fit, test, type = "prob") %>%
  bind_cols(predict(rf_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = rf_pred$truth, 
  estimate = as.numeric(as.character(rf_pred$.pred_0))
)

rf_metrics <- rf_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# XGBoost (Boosting)
xgb_spec <- boost_tree(
  mode = "classification",
  trees = 1000,
  learn_rate = 0.05,
  tree_depth = 6,
  min_n = 5) %>%
  set_engine("xgboost")

xgb_wf <- workflow() %>% 
  add_model(xgb_spec) %>% 
  add_formula(form)

xgb_fit <- xgb_wf %>% 
  fit(train)

xgb_pred <- predict(xgb_fit, test, type = "prob") %>%
  bind_cols(predict(xgb_fit, test, type = "class")) %>%
  mutate(truth = test[[target]])

auc <- roc_auc_vec(
  truth = xgb_pred$truth, 
  estimate = as.numeric(as.character(xgb_pred$.pred_0))
)

xgb_metrics <- xgb_pred %>% 
  metrics_cls(truth = truth, estimate = .pred_class) %>% 
  bind_rows(tibble(
    .metric = "auc",
    .estimate = auc
  ))

# # LightGBM (Boosting)
# lgb_spec <- boost_tree(
#   mode = "classification",
#   trees = 1000, 
#   learn_rate = 0.05, 
#   tree_depth = 6,
#   min_n = 5
# ) %>%
#   set_engine("lightgbm")
# 
# lgb_wf <- workflow() %>% 
#   add_model(lgb_spec) %>% 
#   add_formula(form)
# 
# lgb_fit <- lgb_wf %>% 
#   fit(train)
# 
# lgb_pred <- predict(lgb_fit, test, type = "prob") %>%
#   bind_cols(predict(lgb_fit, test, type = "class")) %>%
#   mutate(truth = test[[target]])
# 
# lgb_metrics <- lgb_pred %>% 
#   metrics_cls(truth = truth, estimate = .pred_class)


# Ən yaxşı model seçimi ----

bind_rows(
  mutate(glm_metrics, model = "GLM"),
  mutate(knn_metrics, model = "KNN"),
  mutate(svm_metrics, model = "SVM"),
  mutate(tree_metrics, model = "Decision Tree"),
  mutate(rf_metrics, model = "Random Forest"),
  mutate(xgb_metrics, model = "XGBoost")#,
  #mutate(lgb_metrics, model = "LightGBM")
  ) %>% 
  select(-.estimator) %>% 
  pivot_wider(names_from = .metric, values_from = .estimate) %>%
  arrange(desc(accuracy))
