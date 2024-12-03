#### Preamble ####
# Purpose: This script performs exploratory data analysis on the cleaned English Women's Football (EWF) data.
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites:  Data should be downloaded and cleaned using scripts 02 and 03

#### Workspace setup ####
library(tidyverse)
library(here)
library(arrow)

# Load cleaned data
cleaned_ewf_matches <- read_parquet(here::here("data", "02-analysis_data", "ewf_matches_cleaned.parquet"))
cleaned_ewf_appearances <- read_parquet(here::here("data", "02-analysis_data", "ewf_appearances_cleaned.parquet"))
cleaned_ewf_standings <- read_parquet(here::here("data", "02-analysis_data", "ewf_standings_cleaned.parquet"))

#### Exploratory Data Analysis ####
# Summary stats
summary_stats <- cleaned_ewf_standings %>%
  summarise(
    total_teams = n(),
    avg_goals_for = mean(goals_for, na.rm = TRUE),
    median_goals_for = median(goals_for, na.rm = TRUE),
    avg_points = mean(points, na.rm = TRUE),
    median_points = median(points, na.rm = TRUE)
  )
print(summary_stats)

# Attendance breakdown
attendance_stats <- cleaned_ewf_matches %>%
  filter(!is.na(attendance)) %>%
  summarise(
    total_matches = n(),
    avg_attendance = mean(attendance, na.rm = TRUE),
    median_attendance = median(attendance, na.rm = TRUE),
    max_attendance = max(attendance, na.rm = TRUE),
    min_attendance = min(attendance, na.rm = TRUE)
  )
print(attendance_stats)