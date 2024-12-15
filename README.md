# Exploring Attendance and Performance Trends in the Women's Super League

By: Rayan Awad Alim.

## Overview

This repository provides all the necessary data, R scripts, and files to understand and reproduce an analysis of match attendance and performance trends in the Women's Super League (WSL).

The analysis examines how attendance has evolved over time and the factors influencing team performance, including goals scored, goals conceded, and league tier. Using Bayesian modeling and exploratory data analysis, the study uncovers key insights:
- Attendance has steadily increased, with significant spikes following major international events like the FIFA Women's World Cup.
- Match attendance correlates positively with home team success, emphasizing the impact of crowd support on match outcomes.
- Offensive and defensive capabilities, as captured by goals scored and conceded, are strong predictors of team success.

The findings offer valuable insights for teams, analysts, and league organizers to enhance fan engagement and improve strategies.

Data for this project was sourced from the English Women's Football (EWF) Database, which includes detailed records of matches, team appearances, and standings. The database provides comprehensive coverage of the Women's Super League and Championship, facilitating robust analysis.


## File Structure

The repo is structured as:

-   `data/raw_data` Contains raw datasets as obtained from the English Women's Football (EWF) Database.
-   `data/analysis_data` Contains cleaned and processed datasets used in the analysis.
-   `data/simulated_data` Contains simulated data used for additional validation and exploration.
-   `models` Contains fitted Bayesian models and diagnostic outputs.
-   `other` Includes details about LLM usage, additional sketches, and exploratory notes.
-   `paper` Contains the Quarto document for the analysis, the reference bibliography file, and the final PDF of the paper.
-   `scripts` : Includes R scripts for data downloading, cleaning, exploratory analysis, modeling, and validation.

## How to Reproduce the Analysis
-   Clone the repository to your local machine.
-   Ensure that R and the required libraries (listed in `scripts/requirements.txt`) are installed
-   Follow the execution order of scripts:
    scripts/01-download_data.R` Downloads raw data from the EWF Database
    scripts/02-clean_data.R` Processes and cleans the raw datasets
    scripts/03-exploratory_data_analysis.R` Performs exploratory analysis and visualization
    scripts/04-model_data.R` Fits Bayesian models and saves results
-   The final paper can be generated using the Quarto document in `paper/`


## Statement on LLM usage

LLMs such as ChatGPT were used for minor coding assistance and debugging support. Full usage can be found on `other/llm_usage/usage.txt`. Also, Rstudio's built-in "Code reformat" tool was used to style code.
