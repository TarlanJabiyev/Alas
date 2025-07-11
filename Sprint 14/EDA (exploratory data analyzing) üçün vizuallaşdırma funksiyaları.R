library(tidyverse)

dataset <- dslabs::gapminder

dataset %>% glimpse()


# “inspectdf” paketi ----
library(inspectdf)

dataset %>% inspect_na() %>% show_plot()
dataset %>% inspect_cor() %>% show_plot()
dataset %>% inspect_num() %>% show_plot()
dataset %>% inspect_cat() %>% show_plot()


# “naniar” paketi ----
library(naniar)

dataset %>%
  select(population, gdp, region) %>%
  gg_miss_upset()


# “correlationfunnel” paketi ----
library(correlationfunnel)

df <- iris %>% binarize(one_hot = T) 

correlation <- df %>% 
  correlate(target = Species__virginica)

correlation %>% 
  plot_correlation_funnel(interactive = F)


# “explore” paketi ----
library(explore)

iris %>% describe()

iris %>% describe(Species)
iris %>% describe(Sepal.Length)

iris %>% describe_tbl()

iris %>% explore(Species)
iris %>% explore(Sepal.Length)

iris %>% explore(Sepal.Length, target = Species)
iris %>% explore(Sepal.Length, Petal.Length, target = Species)


# “dlookr” paketi ----
library(dlookr)

dataset %>% 
  diagnose_web_report(output_format = "dlookr_report", browse = T)


# “SmartEDA” paketi ----
library(SmartEDA)

dataset %>% ExpData()

dataset %>% ExpReport(op_file = "SmartEDA_report.html")
