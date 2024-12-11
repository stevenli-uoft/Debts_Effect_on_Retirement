# The Impact of Household Debt on Retirement Preparedness in Canada

## Overview
This research studies how different types of household debt affect retirement preparedness among Canadian households, using data from Statistics Canada's 2019 Survey of Financial Security. We find that while mortgage debt shows positive associations with retirement preparedness in early career stages, student loan debt significantly impairs retirement readiness, suggesting the need for targeted policy interventions to improve retirement outcomes.

This directory contains the materials for

       "The Impact of Household Debt on Retirement Preparedness in Canada" by S. Li

## Repository Structure
- `data/` contains the processed data used in the analysis
- `models/` contains the fitted multi-linear regression model
- `paper/` contains the Quarto document, bibliography file, and final PDF
- `scripts/` contains R scripts for data processing and model implementation


## Software Requirements

This analysis requires R version 4.4.0 or later, along with the following packages:
- `tidyverse` 2.0.0
- `dplyr` 1.1.4
- `car` 3.1.2
- `sandwich` 3.0.2
- `ggplot2` 3.0.2
- `tibble` 3.2.1
- `knitr` 1.48
- `kableExtra` 1.4.0


## Reproduction Instructions
To reproduce the analysis and paper, follow these steps:
1. Clone the repository to your local machine.
2. Go to `scripts/` and run `data_cleaning.R`. This script processes the raw SFS 2019 data for our regression model and analysis.model.
5. Go to `scripts/` and run `model_data.R`: This script uses the processed data to build the regression model, and saves it to `models/`
6. Open the Quarto document in `paper/paper.qmd` and render the PDF file. This will create the necessary figures and tables in the paper.
