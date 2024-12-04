#### Preamble ####
# Purpose: Simulates a dataset of Women's Super League matches, including match attendance, outcomes, and team performances.
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Make sure you are in the `EnglishWomensFootballAnalysis` rproj


#### Workspace setup ####
required_packages <- c("tidyverse", "here")
for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, character.only = TRUE)
  }
}

library(tidyverse)
library(here)

set.seed(2024)


#### Simulate data ####
# Define teams and tiers
teams <-
  c("Team A",
    "Team B",
    "Team C",
    "Team D",
    "Team E",
    "Team F",
    "Team G",
    "Team H")
tiers <- c("Super League", "Championship")

# Define probabilities for results and tiers
result_probs <- c(Home_Win = 0.5,
                  Away_Win = 0.3,
                  Draw = 0.2)
tier_probs <- c(0.7, 0.3)

# Generate simulated match data
n_matches <- 200
match_dates <-
  seq.Date(
    from = as.Date("2020-01-01"),
    to = as.Date("2023-12-31"),
    length.out = n_matches
  )

simulated_matches <- data.frame(
  match_id = 1:n_matches,
  date = sample(match_dates, n_matches, replace = FALSE),
  home_team = sample(teams, n_matches, replace = TRUE),
  away_team = sample(teams, n_matches, replace = TRUE),
  attendance = sample(500:50000, n_matches, replace = TRUE),
  result = sample(
    names(result_probs),
    n_matches,
    replace = TRUE,
    prob = result_probs
  )
)

# Ensure home_team != away_team
simulated_matches <- simulated_matches %>%
  filter(home_team != away_team)

# Generate team appearances
simulated_appearances <- simulated_matches %>%
  pivot_longer(
    cols = c(home_team, away_team),
    names_to = "team_type",
    values_to = "team"
  ) %>%
  mutate(
    goals_for = sample(0:5, n(), replace = TRUE),
    goals_against = sample(0:5, n(), replace = TRUE),
    tier = sample(tiers, n(), replace = TRUE, prob = tier_probs)
  )

# Generate standings data
simulated_standings <- simulated_appearances %>%
  group_by(team) %>%
  summarize(
    points = sum(ifelse(
      goals_for > goals_against,
      3,
      ifelse(goals_for == goals_against, 1, 0)
    )),
    goals_scored = sum(goals_for),
    goals_conceded = sum(goals_against),
    matches_played = n(),
    tier = first(tier)
  ) %>%
  ungroup()

#### Save data ####
# Save simulated data
write.csv(
  simulated_matches,
  here::here("data", "00-simulated_data", "simulated_matches.csv"),
  row.names = FALSE
)
write.csv(
  simulated_appearances,
  here::here("data", "00-simulated_data", "simulated_appearances.csv"),
  row.names = FALSE
)
write.csv(
  simulated_standings,
  here::here("data", "00-simulated_data", "simulated_standings.csv"),
  row.names = FALSE
)