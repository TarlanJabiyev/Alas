library(tidyverse)
library(Boruta)

df <- read_csv("churn.csv")

df %>% glimpse()

df <- df %>% 
  select(-id) %>% 
  mutate(y = as_factor(y))


# Boruta alqoritması ilə dəyişənlərin seçilməsi
set.seed(123)
boruta <- Boruta(y ~ ., data = df) %>% 
  TentativeRoughFix()
boruta


# Seçilən dəyişənlər
boruta.df <- boruta %>% attStats()
boruta.df %>% 
  filter(decision == "Confirmed") %>% 
  rownames()

