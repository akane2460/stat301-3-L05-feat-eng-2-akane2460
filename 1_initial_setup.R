# L05 Feature Engineering II ----
# Processing training, creating resamples

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)

# handle common conflicts
tidymodels_prefer()

# load data----
wildfires <- read_csv(here("data/wildfires.csv")) |>
  janitor::clean_names() |>
  mutate(
    wlf = factor(wlf),
    winddir = factor(winddir, levels = c("N", "NE", "E", "SE", "S", "SW", "W", "NW")) 
    ) |> 
  select(-burned)

# missingness check
wildfires |> 
  count(wlf)

wildfires |> 
  naniar::miss_var_summary() |> 
  filter(n_miss > 0)

# split data
set.seed(2498)
wildfires_split <- 
  wildfires |> 
  initial_split(
    prop = .75,
    strata = wlf
  )

wildfires_train <- training(wildfires_split)
wildfires_test <- testing(wildfires_split)

# resamples
set.seed(0972)
wildfires_folds <-
  wildfires_train |> 
  vfold_cv(v = 5, repeats = 5, strata = wlf)

# save out items
save(
  wildfires_split,
  file = here("data/wildfires_split.rda")
)

save(
  wildfires_train,
  file = here("data/wildfires_train.rda")
)

save(
  wildfires_test,
  file = here("data/wildfires_test.rda")
)

save(
  wildfires_folds,
  file = here("data/wildfires_folds.rda")
)
