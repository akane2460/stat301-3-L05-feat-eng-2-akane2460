# L05 Feature Engineering II ----
# missingness & factor EDA

# Load package(s)
library(tidymodels)
library(tidyverse)
library(here)

# load data
wildfires <- read_csv(here("data/wildfires.csv")) |>
  janitor::clean_names()

# skim
wildfires |> skimr::skim_without_charts()

# explore target
wildfires |> 
  ggplot(aes(x = wlf)) +
  geom_bar()

# explore some other factors
wildfires |> 
  ggplot(aes(x = winddir)) +
  geom_bar()

wildfires |> 
  ggplot(aes(x = traffic)) +
  geom_bar()

wildfires |> 
  ggplot(aes(x = x, y = y)) +
  geom_point()

wildfires |> 
  ggplot(aes(x = temp)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = humidity)) +
  geom_boxplot()

wildfires |> 
  ggplot(aes(x = windspd)) +
  geom_boxplot()

wildfires |> 
  ggplot(aes(x = rain)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = days)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = vulnerable)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = other)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = ranger)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = pre1950)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = heli)) +
  geom_histogram()

wildfires |> 
  ggplot(aes(x = resources)) +
  geom_histogram()
