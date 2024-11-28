# L05 Feature Engineering II ----
# Tuning for MARS advanced ----

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(tictoc)
library(here)
library(doMC)
library(earth)

# Handle conflicts
tidymodels_prefer()

# parallel processing ----
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores - 1)

# load resamples ----
load(here("data/wildfires_folds.rda"))

# load preprocessing/recipe ----
load(here("recipes/recipe_advanced.rda"))

# model specifications ----
mars_spec <- mars(
  num_terms = tune(),
  prod_degree = tune()
) |> 
  set_mode("classification") |> 
  set_engine("earth")

# define workflow ----
mars_wflow <-
  workflow() |> 
  add_model(mars_spec) |> 
  add_recipe(recipe_advanced)

# hyperparameter tuning values ----
mars_params <- hardhat::extract_parameter_set_dials(mars_spec) |> 
  update(
    num_terms = num_terms(range = c(1L, 5L))
  )

rec_params <- hardhat::extract_parameter_set_dials(recipe_advanced) |> 
  update(
    num_comp = num_comp(range = c(1L, 10L))
  )

all_params <- bind_rows(mars_params, rec_params)

# build grid
mars_grid <- grid_regular(all_params, levels = 24)

# tune/fit workflow/model ----
tic.clearlog() # clear log
tic("mars_advanced") # start clock

tune_mars_advanced <- tune_grid(mars_wflow, 
                          resamples = wildfires_folds,
                          grid = mars_grid,
                          control = control_grid(save_workflow = TRUE)
)

toc(log = TRUE)

# Extract runtime info
time_log <- tic.log(format = FALSE)

tictoc_mars_advanced <- tibble(
  model = time_log[[1]]$msg,
  start_time = time_log[[1]]$tic,
  end_time = time_log[[1]]$toc,
  runtime = end_time - start_time
)

# write out results (fitted/trained workflows & runtime info) ----
save(
  tune_mars_advanced,
  tictoc_mars_advanced,
  file = here("results/mars_advanced.rda")
)