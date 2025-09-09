library(tidyverse)
library(inspectdf)
library(tidymodels)
library(bonsai)

data <- read_csv("insurance.csv")

data %>% glimpse()

data %>% inspect_na()

target <- "charges"


# Datanın bölünməsi - Splitting the data ----
data_split <- data %>% 
  initial_split(prop = 0.8, strata = target)
train <- training(data_split)
test  <- testing(data_split)


# Alqoritmalar ----

form <- as.formula(paste(target, "~ ."))

metrics_reg <- metric_set(mae, rmse, rsq)

# GLM — Linear Regression
glm_spec <- linear_reg() %>% 
  set_engine("lm")

glm_wf <- workflow() %>% 
  add_model(glm_spec) %>% 
  add_formula(form)

glm_fit  <- glm_wf %>% 
  fit(train)

glm_pred <- glm_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

glm_metrics <- glm_pred %>% 
  metrics_reg(truth, .pred)

# KNN 
knn_spec <- nearest_neighbor(
  mode = "regression",
  neighbors = 3,
  weight_func = "rectangular") %>%
  set_engine("kknn")

knn_wf <- workflow() %>% 
  add_model(knn_spec) %>% 
  add_formula(form)

knn_fit <- knn_wf %>% 
  fit(train)

knn_pred <- knn_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

knn_metrics <- knn_pred %>% 
  metrics_reg(truth, .pred)

# SVM 
svm_spec <- svm_rbf(mode = "regression") %>%
  set_engine("kernlab")

svm_wf <- workflow() %>% 
  add_model(svm_spec) %>% 
  add_formula(form)

svm_fit <- svm_wf %>% 
  fit(train)

svm_pred <- svm_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

svm_metrics <- svm_pred %>% 
  metrics_reg(truth, .pred)

# Decision Tree
tree_spec <- decision_tree(
  mode = "regression",
  tree_depth = 15, #the maximum number of splits from root to leaf
                   #large value: high variance, can overfit
                   #small value: high bias, low variance
  min_n = 2 #minimum row count in a node
            #large value: less overfitting, high bias, low variance
            #smal value: can overfit, low bias, high variance
  ) %>%
  set_engine("rpart")

tree_wf <- workflow() %>% 
  add_model(tree_spec) %>% 
  add_formula(form)

tree_fit <- tree_wf %>% 
  fit(train)

tree_pred <- tree_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

tree_metrics <- tree_pred %>% 
  metrics_reg(truth, .pred)

# Random Forest (Bagging)
rf_spec <- rand_forest(
  mode = "regression",
  trees = 500,
  min_n = 5) %>%
  set_engine("ranger")

rf_wf <- workflow() %>% 
  add_model(rf_spec) %>% 
  add_formula(form)

rf_fit <- rf_wf %>% 
  fit(train)

rf_pred <- rf_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

rf_metrics <- rf_pred %>% 
  metrics_reg(truth, .pred)

# XGBoost (Boosting)
xgb_spec <- boost_tree(
  mode = "regression",
  trees = 1000, #more trees: higher capacity and training time. Usually paired with a smaller learn_rate
  learn_rate = 0.05, #step size reduction per boosting step
                     #small (0.01–0.1): slower, steadier learning, needs more trees, often better generalization
                     #large (0.2–0.3): faster, risk of overfit if trees is also large
  tree_depth = 6, #the maximum number of splits from root to leaf
                  #large (6–12): high variance, can overfit
                  #small (3–6): high bias, low variance
  min_n = 5 #large (5–20): less overfitting, high bias, low variance
             #smal (1–2): can overfit, low bias, high variance
  ) %>%
  set_engine("xgboost")

xgb_wf <- workflow() %>% 
  add_model(xgb_spec) %>% 
  add_formula(form)

xgb_fit <- xgb_wf %>% 
  fit(train)

xgb_pred <- xgb_fit %>% 
  predict(test) %>% 
  mutate(truth = test[[target]])

xgb_metrics <- xgb_pred %>% 
  metrics_reg(truth, .pred)

# # LightGBM (Boosting)
# lgb_spec <- boost_tree(
#   mode = "regression",
#   trees = 1000, 
#   learn_rate = 0.05, 
#   tree_depth = 6,
#   min_n = 5
#   ) %>%
#   set_engine("lightgbm")
# 
# lgb_wf <- workflow() %>% 
#   add_model(lgb_spec) %>% 
#   add_formula(form)
# 
# lgb_fit <- lgb_wf %>% 
#   fit(train)
# 
# lgb_pred <- lgb_fit %>% 
#   predict(test) %>% 
#   mutate(truth = test[[target]])
# 
# lgb_metrics <- lgb_pred %>% 
#   metrics_reg(truth, .pred)


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
  arrange(rmse)
