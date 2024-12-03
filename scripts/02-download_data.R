#### Preamble ####
# Purpose: Downloads and saves the data from https://github.com/probjects/ewf-database/tree/main/data
# Author: Rayan Awad Alim
# Date: 3 December 2024
# Contact: rayan.alim@mail.utoronto.ca
# License: MIT

#### Workspace setup ####
required_packages <- c("httr", "readr", "here")
for (p in required_packages) {
  if (!require(p, character.only = TRUE)) {
    install.packages(p, character.only = TRUE)
  }
}

library(httr)
library(readr)
library(here)

#### Download data ####
base_url <- "https://raw.githubusercontent.com/probjects/ewf-database/main/data/"
datasets <- c("ewf_matches.csv", "ewf_appearances.csv", "ewf_standings.csv")

# Download each dataset to raw data file
for (dataset in datasets) {
  dataset_url <- paste0(base_url, dataset)
  dest_file <- here("data", "01-raw_data", dataset)
  
  #GET request to download the data
  response <- GET(dataset_url)
  
  if (status_code(response) == 200) {
    writeBin(content(response, "raw"), dest_file)
    message(paste("Downloaded", dataset, "successfully."))
  } else {
    warning(paste("Failed to download", dataset, "with status code:", status_code(response)))
  }
}

#### Save data ####
ewf_matches <- read_csv(here("data", "01-raw_data", "ewf_matches.csv"))
ewf_appearances <- read_csv(here("data", "01-raw_data", "ewf_appearances.csv"))
ewf_standings <- read_csv(here("data", "01-raw_data", "ewf_standings.csv"))