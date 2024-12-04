#### Preamble ####
# Purpose: Cleans the raw datasets and saves as parquets for analysis
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Should have ran 02-download_data.R Make sure you are in the `EnglishWomensFootballAnalysis` rproj

#### Workspace setup ####
required_packages <-
  c("tidyverse", "lubridate", "arrow", "here", "stringr")
for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, character.only = TRUE)
  }
}

library(tidyverse)
library(lubridate)
library(arrow)
library(here)
library(stringr)

#### Clean Data ####
# Clean `ewf_matches`
cleaned_ewf_matches <- ewf_matches %>%
  filter(!is.na(attendance)) %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    attendance = as.numeric(str_replace_all(attendance, ",", "")),
    result = as.factor(result),
    home_team_win = as.logical(home_team_win),
    away_team_win = as.logical(away_team_win),
    draw = as.logical(draw)
  ) %>%
  mutate(across(where(is.character), str_trim))

# Clean `ewf_appearances`
cleaned_ewf_appearances <- ewf_appearances %>%
  filter(!is.na(team_name)) %>%
  mutate(
    date = as.Date(date, format = "%Y-%m-%d"),
    attendance = as.numeric(str_replace_all(attendance, ",", "")),
    result = as.factor(result),
    win = as.logical(win),
    loss = as.logical(loss),
    draw = as.logical(draw),
    goals_for = as.numeric(goals_for),
    goals_against = as.numeric(goals_against),
    goal_difference = as.numeric(goal_difference),
    note = replace_na(note, "None")
  ) %>%
  mutate(across(where(is.character), str_trim))

# Clean `ewf_standings`
cleaned_ewf_standings <- ewf_standings %>%
  filter(!is.na(team_name)) %>%
  mutate(
    tier = as.factor(tier),
    division = as.factor(division),
    played = as.numeric(played),
    wins = as.numeric(wins),
    draws = as.numeric(draws),
    losses = as.numeric(losses),
    goals_for = as.numeric(goals_for),
    goals_against = as.numeric(goals_against),
    goal_difference = as.numeric(goal_difference),
    points = as.numeric(points),
    point_adjustment = replace_na(point_adjustment, 0),
    season_outcome = as.factor(season_outcome)
  ) %>%
  mutate(across(where(is.character), str_trim))

#### Save Cleaned Data as Parquet Files ####
write_parquet(
  cleaned_ewf_matches,
  here("data", "02-analysis_data", "ewf_matches_cleaned.parquet")
)
write_parquet(
  cleaned_ewf_appearances,
  here(
    "data",
    "02-analysis_data",
    "ewf_appearances_cleaned.parquet"
  )
)
write_parquet(
  cleaned_ewf_standings,
  here("data", "02-analysis_data", "ewf_standings_cleaned.parquet")
)