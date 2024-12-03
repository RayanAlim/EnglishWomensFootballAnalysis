#### Preamble ####
# Purpose: Cleans the raw datasets and saves as parquets for analysis
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Should have ran 02-download_data.R

#### Workspace setup ####
library(tidyverse)

### Read Data
ewf_matches <- read_csv(here("data", "01-raw_data", "ewf_matches.csv"))
ewf_appearances <- read_csv(here("data", "01-raw_data", "ewf_appearances.csv"))
ewf_standings <- read_csv(here("data", "01-raw_data", "ewf_standings.csv"))

#### Clean data ####
cleaned_ewf_matches <- ewf_matches %>%
  filter(!is.na(attendance)) %>%
  mutate(date = as.Date(date, format = "%d/%m/%Y"))

cleaned_ewf_appearances <- ewf_appearances %>%
  filter(!is.na(team_name)) %>%
  mutate(date = as.Date(date, format = "%d/%m/%Y"))

cleaned_ewf_standings <- ewf_standings %>%
  filter(!is.na(team_name))

# Save cleaned data as parquet files
write_parquet(cleaned_ewf_matches, here("data", "02-analysis_data", "ewf_matches_cleaned.parquet"))
write_parquet(cleaned_ewf_appearances, here("data", "02-analysis_data", "ewf_appearances_cleaned.parquet"))
write_parquet(cleaned_ewf_standings, here("data", "02-analysis_data", "ewf_standings_cleaned.parquet"))