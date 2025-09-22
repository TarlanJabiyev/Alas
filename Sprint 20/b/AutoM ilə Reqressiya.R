library(tidyverse) 
library(inspectdf)
library(h2o) 

data <- mlr3data::moneyball

data %>% glimpse()

data %>% inspect_na()


# H2O
h2o.init()

h2o_data <- data %>% as.h2o()
h2o_data %>% class()


# Datanın bölünməsi
h2o_data <- h2o_data %>% h2o.splitFrame(ratios = c(0.8, 0.1), seed = 123)
train <- h2o_data[[1]]
valid <- h2o_data[[2]]
test <- h2o_data[[3]]

target <- "rs"
features <- data %>% select(-all_of(target)) %>% names()


# AutoML
model <- h2o.automl(
  x = features, 
  y = target,
  training_frame    = train,
  validation_frame  = valid,
  leaderboard_frame = test,
  stopping_metric = "MAE",
  nfolds = 10, 
  seed = 123,
  max_runtime_secs = 120)

model@leaderboard %>% as.data.frame()
best_model <- model@leader


# Reqressiya Modelinin Perormansının Qiymətləndirilməsi
train_eval <- best_model %>% 
  h2o.performance(train = TRUE)

train_eval %>% 
  h2o.r2()

val_eval <- best_model %>% 
  h2o.performance(valid = TRUE)

val_eval %>% 
  h2o.r2()

xval_eval <- best_model %>% 
  h2o.performance(xval = TRUE)

xval_eval %>% 
  h2o.r2()

test_eval <- best_model %>% 
  h2o.performance(newdata = test)

test_eval %>% 
  h2o.r2()


# Proqnozlar
y_pred <- best_model %>% h2o.predict(test) %>% as.data.frame()
pred <- y_pred$predict
