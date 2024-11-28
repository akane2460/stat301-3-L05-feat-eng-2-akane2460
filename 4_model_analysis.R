# L05 Feature Engineering II ----
# Model selection/comparison & analysis

# Load package(s) & set seed ----
library(tidymodels)
library(tidyverse)
library(here)

# Handle conflicts
tidymodels_prefer()

# load data
load("data/wildfires_test.rda")

# load tuned fits
load(here("results/mars_ks.rda"))
load(here("results/mars_advanced.rda"))

best_results_ks <- select_best(tune_mars_ks, metric = "accuracy")
best_results_advanced <- select_best(tune_mars_advanced, metric = "accuracy")

# roc auc
collect_metrics(tune_mars_ks) |> 
  filter(.metric == "roc_auc") |> 
  arrange(-mean)

advanced_metric <- collect_metrics(tune_mars_advanced) |> 
  filter(.metric == "roc_auc") |> 
  arrange(-mean) |> 
  slice(1) |> 
  select(.metric, mean, std_err)

runtimes_advanced <- tictoc_mars_advanced |> select(runtime)

bind_cols(advanced_metric, runtimes_advanced) |> 
  knitr::kable()

