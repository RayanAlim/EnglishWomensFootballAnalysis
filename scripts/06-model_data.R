#### Preamble ####
# Purpose: Create predictive models for match attendance, match outcomes, and team performance in Women's Super League.
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Data should be downloaded and cleaned using scripts 02 and 03, # Pre-requisites: Make sure you are in the `EnglishWomensFootballAnalysis` rproj


#### Workspace setup ####
required_packages <- c("tidyverse", "here", "caret", "arrow")
for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, character.only = TRUE)
  }
}

library(tidyverse)
library(here)
library(caret)
library(arrow)

#### Read data ####
cleaned_ewf_matches <-
  read_parquet(here("data", "02-analysis_data", "ewf_matches_cleaned.parquet"))

#### Model 1: Predicting Attendance ####
# Linear Regression to Predict Match Attendance
# Prepare data for modeling
attendance_model_data <- cleaned_ewf_matches %>%
  filter(!is.na(attendance)) %>%
  mutate(home_team = as.factor(home_team_id),
         away_team = as.factor(away_team_id))

# Fit a linear regression model to predict attendance
attendance_model <- lm(
  attendance ~ home_team + away_team + home_team_score_margin + away_team_score_margin,
  data = attendance_model_data
)

# Summary of the attendance model
summary(attendance_model)

#### Model 2: Predicting Match Outcome ####
# Logistic Regression to Predict the Probability of a Home Win
# Prepare data for outcome modeling
outcome_model_data <- cleaned_ewf_matches %>%
  filter(!is.na(result)) %>%
  mutate(home_win = ifelse(result == "Home team win", 1, 0),
         tier = as.factor(tier))

# Fit a logistic regression model for predicting match outcomes
outcome_model <- glm(
  home_win ~ attendance + tier + home_team_score_margin + away_team_score_margin,
  data = outcome_model_data,
  family = binomial(link = "logit")
)

# Summary of the outcome model
summary(outcome_model)

#### Model 3: Predicting Team Performance (Simplified Approach) ####
# Linear Regression to Predict Team Points Based on Goals For and Against
team_performance_model_data <- cleaned_ewf_standings %>%
  filter(!is.na(points),!is.na(goals_for),!is.na(goals_against)) %>%
  mutate(tier = as.factor(tier))

# Fit a linear regression model for predicting team performance
team_performance_model <- lm(points ~ goals_for + goals_against + tier,
                             data = team_performance_model_data)

# Summary of the team performance model
summary(team_performance_model)

#### Save Models ####
# Save models as RDS files for future use
saveRDS(attendance_model, here("models", "attendance_model.rds"))
saveRDS(outcome_model, here("models", "outcome_model.rds"))
saveRDS(team_performance_model,
        here("models", "team_performance_model.rds"))
