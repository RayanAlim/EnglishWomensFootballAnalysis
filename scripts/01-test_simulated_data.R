#### Preamble ####
# Purpose: Tests the structure and validity of the simulated Women's Super League datasets.
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Simulated data must have been generated using `00-simulate_data.R`.
# Make sure you are in the `EnglishWomensFootballAnalysis` rproj.

#### Workspace setup ####
required_packages <- c("tidyverse", "here", "testthat")
for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, character.only = TRUE)
  }
}

library(tidyverse)
library(here)
library(testthat)

# Load simulated data
simulated_matches <-
  read_csv(here("data", "00-simulated_data", "simulated_matches.csv"))
simulated_appearances <-
  read_csv(here("data", "00-simulated_data", "simulated_appearances.csv"))
simulated_standings <-
  read_csv(here("data", "00-simulated_data", "simulated_standings.csv"))

#### Test Data ####
# Test that the datasets are successfully loaded
test_that("datasets are loaded successfully", {
  expect_true(exists("simulated_matches"), info = "The 'simulated_matches' dataset could not be loaded.")
  expect_true(exists("simulated_appearances"), info = "The 'simulated_appearances' dataset could not be loaded.")
  expect_true(exists("simulated_standings"), info = "The 'simulated_standings' dataset could not be loaded.")
})

# Test the structure of the datasets

# Test if matches dataset has expected columns
test_that("matches dataset has expected columns", {
  expected_columns_matches <-
    c("match_id",
      "date",
      "home_team",
      "away_team",
      "attendance",
      "result")
  expect_true(all(expected_columns_matches %in% colnames(simulated_matches)),
              info = "The 'simulated_matches' dataset does not have the expected columns.")
})

# Test if appearances dataset has expected columns
test_that("appearances dataset has expected columns", {
  expected_columns_appearances <-
    c("match_id",
      "team_type",
      "team",
      "goals_for",
      "goals_against",
      "tier")
  expect_true(all(
    expected_columns_appearances %in% colnames(simulated_appearances)
  ),
  info = "The 'simulated_appearances' dataset does not have the expected columns.")
})

# Test if standings dataset has expected columns
test_that("standings dataset has expected columns", {
  expected_columns_standings <-
    c("team",
      "points",
      "goals_scored",
      "goals_conceded",
      "matches_played",
      "tier")
  expect_true(all(
    expected_columns_standings %in% colnames(simulated_standings)
  ),
  info = "The 'simulated_standings' dataset does not have the expected columns.")
})

# Test that match_id in appearances exists in matches
test_that("match_id in appearances exists in matches", {
  expect_true(all(
    simulated_appearances$match_id %in% simulated_matches$match_id
  ),
  info = "Some 'match_id's in 'simulated_appearances' do not exist in 'simulated_matches'.")
})

# Test that there are no missing values in critical columns of matches dataset
test_that("no missing values in critical columns of matches dataset", {
  critical_columns_matches <-
    c("match_id",
      "date",
      "home_team",
      "away_team",
      "attendance",
      "result")
  expect_true(all(complete.cases(simulated_matches[critical_columns_matches])),
              info = "There are missing values in critical columns of 'simulated_matches'.")
})

# Test that there are no missing values in critical columns of appearances dataset
test_that("no missing values in critical columns of appearances dataset", {
  critical_columns_appearances <-
    c("match_id", "team", "goals_for", "goals_against", "tier")
  expect_true(all(complete.cases(simulated_appearances[critical_columns_appearances])),
              info = "There are missing values in critical columns of 'simulated_appearances'.")
})

# Test that home_team and away_team are different for all matches
test_that("home_team and away_team are different for all matches", {
  expect_true(all(simulated_matches$home_team != simulated_matches$away_team),
              info = "Some matches have the same 'home_team' and 'away_team'.")
})

# Test that attendance is non-negative in matches dataset
test_that("attendance is non-negative in matches dataset", {
  expect_true(all(simulated_matches$attendance >= 0),
              info = "There are negative values in 'attendance' in 'simulated_matches'.")
})

# Test that there are no duplicate match IDs in matches dataset
test_that("no duplicate match IDs in matches dataset", {
  expect_equal(n_distinct(simulated_matches$match_id),
               nrow(simulated_matches),
               info = "There are duplicate 'match_id's in 'simulated_matches'.")
})

# Test that standings dataset has unique team entries
test_that("standings dataset has unique team entries", {
  expect_equal(n_distinct(simulated_standings$team),
               nrow(simulated_standings),
               info = "There are duplicate team entries in 'simulated_standings'.")
})

# Test that points in standings dataset are non-negative
test_that("points are non-negative in standings dataset", {
  expect_true(all(simulated_standings$points >= 0),
              info = "There are negative points in 'simulated_standings'.")
})

# Test if goals_for and goals_against in appearances are non-negative
test_that("goals_for and goals_against are non-negative in appearances dataset",
          {
            expect_true(
              all(simulated_appearances$goals_for >= 0) &&
                all(simulated_appearances$goals_against >= 0),
              info = "There are negative values in 'goals_for' or 'goals_against' in 'simulated_appearances'."
            )
          })