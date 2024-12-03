#### Preamble ####
# Purpose: Tests different aspects of the analysis data
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites:  Data should be downloaded and cleaned using scripts 02 and 03

#### Workspace setup ####
library(tidyverse)
library(testthat)
library(arrow)
library(here)

# Load cleaned data
cleaned_ewf_matches <- read_parquet(here("data", "02-analysis_data", "ewf_matches_cleaned.parquet"))
cleaned_ewf_appearances <- read_parquet(here("data", "02-analysis_data", "ewf_appearances_cleaned.parquet"))
cleaned_ewf_standings <- read_parquet(here("data", "02-analysis_data", "ewf_standings_cleaned.parquet"))

#### Test data ####
# Test that there are no missing values in critical columns of matches dataset
critical_columns_matches <- c("season_id", "match_id", "home_team_name", "away_team_name", "date", "score")
test_that("no missing values in critical columns of matches dataset", {
  expect_true(all(complete.cases(cleaned_ewf_matches[critical_columns_matches])))
})

# Test that the standings dataset has expected number of columns
expected_columns_standings <- c("season_id", "season", "tier", "division", "position", "team_id", "team_name", "played", "wins", "draws", "losses", "goals_for", "goals_against", "goal_difference", "points", "point_adjustment", "season_outcome")
test_that("standings dataset has expected columns", {
  expect_equal(colnames(cleaned_ewf_standings), expected_columns_standings)
})

# Test that there are no missing values in critical columns of standings dataset
critical_columns_standings <- c("season_id", "team_name", "position", "points")
test_that("no missing values in critical columns of standings dataset", {
  expect_true(all(complete.cases(cleaned_ewf_standings[critical_columns_standings])))
})

# Test that 'date' columns are properly formatted as Date type in all datasets
test_that("date columns are properly formatted as Date type", {
  expect_s3_class(cleaned_ewf_matches$date, "Date")
  expect_s3_class(cleaned_ewf_appearances$date, "Date")
})

# Test that there are no duplicate match IDs in matches dataset
test_that("no duplicate match IDs in matches dataset", {
  expect_equal(length(unique(cleaned_ewf_matches$match_id)), nrow(cleaned_ewf_matches))
})

# Test that standings dataset contains expected tiers (1 or 2)
test_that("standings dataset contains only valid tiers", {
  expect_true(all(cleaned_ewf_standings$tier %in% c(1, 2)))
})