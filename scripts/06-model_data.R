#### Preamble ####
# Purpose: This script creates a model to predict team performance based on match statistics
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Data should be downloaded and cleaned using scripts 02 and 03

#### Workspace setup ####
library(tidyverse)
library(rstanarm)
library(here)

#### Read data ####
analysis_data <- read_parquet(here::here("data", "02-analysis_data", "ewf_standings_cleaned.parquet"))

# Clean the data
analysis_data_cleaned <- analysis_data %>%
  filter(!is.na(points), !is.na(goals_for), !is.na(goals_against), !is.na(tier)) %>%
  mutate(
    tier = as.factor(tier),
    goals_for = as.numeric(goals_for),
    goals_against = as.numeric(goals_against),
    points = as.numeric(points)
  )

### Model data ####
# Fit the Bayesian model using 'points' as the dependent variable to predict team performance.
team_performance_model <- stan_glm(
  formula = points ~ goals_for + goals_against + tier,
  data = analysis_data_cleaned,
  family = gaussian(),
  prior = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_intercept = normal(location = 0, scale = 2.5, autoscale = TRUE),
  prior_aux = exponential(rate = 1, autoscale = TRUE),
  seed = 853
)

#### Save model ####
saveRDS(
  team_performance_model,
  file = here::here("models", "team_performance_model.rds")
)
write_parquet(analysis_data_cleaned, here::here("data", "02-analysis_data", "model_data.parquet"))

# Summary of the model
summary(team_performance_model)

# Plotting model diagnostics
plot(team_performance_model, plotfun = "hist")
plot(team_performance_model, plotfun = "trace")