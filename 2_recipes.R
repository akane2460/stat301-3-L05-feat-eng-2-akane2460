# L05 Feature Engineering II ----
# Setup preprocessing/recipes/feature engineering

# Load package(s) ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

# load training data ----
load(here("data/wildfires_train.rda"))

###############################################################################
# Minimal Kitchen Sink recipe for MARS
###############################################################################

recipe_ks <- recipe(wlf ~ .,  data = wildfires_train) |> 
  step_dummy(all_nominal_predictors()) |>
  step_nzv(all_numeric_predictors()) |> 
  step_normalize(all_numeric_predictors())

# recipe_ks |> 
#   prep() |> 
#   bake(new_data = NULL) |> 
#   glimpse()

save(recipe_ks, file = here("recipes/recipe_ks.rda"))

###############################################################################
# More advanced recipe(s) for MARS
###############################################################################

recipe_advanced <- recipe(wlf ~ .,  data = wildfires_train) |> 
  step_YeoJohnson(windspd) |> 
  step_dummy(all_nominal_predictors()) |>
  step_corr(all_numeric_predictors()) |> 
  step_interact(terms = ~.*.) |> 
  step_nzv(all_numeric_predictors()) |> 
  step_normalize(all_numeric_predictors()) |> 
  step_pca(all_numeric_predictors(), num_comp = tune())

# recipe_advanced |>
#   prep() |>
#   bake(new_data = NULL) |>
#   glimpse()

save(recipe_advanced, file = here("recipes/recipe_advanced.rda"))
