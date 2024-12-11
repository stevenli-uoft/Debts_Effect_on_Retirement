#### Preamble ####
# Purpose: Cleans and process the Survey of Financial Security (SFS) data
# Author: Steven Li
# Contact: stevency.li@mail.utoronto.ca

#### Workspace setup ####
library(tidyverse)
library(dplyr)

# Read raw data
raw_data <- read_csv("data/SFS_2019_ENG.csv")

# Select required variables
clean_data <- raw_data %>%
  select(
    # Debt variables  
    pwdprmor,    # Mortgage debt
    pwdstcrd,    # Credit card debt
    pwdsloan,    # Student loan debt
    
    # Retirement assets
    pwarppg,     # Employer pension plans
    pwarrspl,    # RRSP investments
    pwarrif,     # Retirement income funds
    pwaotpen,    # Other retirement funds
    pwatfs,      # Tax-Free Savings Accounts
    
    # Income
    pefatinc,    # After-tax income
    
    # Control variables
    pweight,     # Survey weights (don't use as predictor)
    pagemieg,    # Age of major income earner
    peducmie    # Education level (key socioeconomic control)
    # pnbearg,     # Number of earners (affects household financial capacity)
    # pftenur,     # Home ownership status (related to mortgage debt)
    # pregion,     # Region (controls for geographic differences)
    # pfsz,        # Household size
    # pwaprval,    # Principal residence value
    # pinhert      # Inheritances received
  ) %>%
  mutate(pagemieg = as.numeric(pagemieg))


# Create total retirement assets variable
clean_data <- clean_data %>%
  mutate(
    total_retirement_assets = pwarppg + pwarrspl + pwarrif + pwaotpen + pwatfs,

    # Create retirement preparedness ratio
    retirement_preparedness = total_retirement_assets / pefatinc,
    
    # Debt binary indicators
    has_mortage = if_else(pwdprmor > 0, 1, 0),
    has_cc = if_else(pwdstcrd > 0, 1, 0),
    has_student = if_else(pwdsloan > 0, 1, 0)
  )

clean_data <- clean_data %>% 
  filter(
    retirement_preparedness > 0,
    pagemieg >= 6
    )

# Removing outliers
clean_data <- clean_data[clean_data$retirement_preparedness >= quantile(clean_data$retirement_preparedness, 0.05) &
                           clean_data$retirement_preparedness <= quantile(clean_data$retirement_preparedness, 0.95),]

clean_data <- clean_data %>%
  mutate(
    retirement_preparedness_log = log(retirement_preparedness + 2)
  )

write_csv(clean_data, "data/cleaned_SFS.csv")