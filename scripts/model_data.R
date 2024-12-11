#### Preamble ####
# Purpose: Creates multi-linear regression model to find debt and retirement relationship
# Author: Steven Li
# Contact: stevency.li@mail.utoronto.ca

# Load required libraries
library(tidyverse)
library(dplyr)
library(car)       
library(sandwich) 

clean_data <- read_csv("data/cleaned_SFS.csv")

# Convert categorical variables to factors
clean_data <- clean_data %>% mutate(
  pagemieg = factor(pagemieg),
  peducmie = factor(peducmie),
  has_mortage = factor(has_mortage),
  has_cc = factor(has_cc),
  has_student = factor(has_student)
)

retirement_model <- lm(retirement_preparedness_log ~ 
                                        has_mortage + 
                                        has_cc + 
                                        has_student + 
                                        pagemieg + 
                                        peducmie +
                                        has_mortage:pagemieg +
                                        has_cc:pagemieg +
                                        has_student:pagemieg,
                                        weights = pweight,
                                        data = clean_data)

# # Check VIF for multicollinearity
# vif_values <- vif(retirement_model)
# print("Variance Inflation Factors:")
# print(vif_values)

# Calculate robust standard errors and coefficient table
robust_se <- sqrt(diag(vcovHC(retirement_model, type = "HC1")))

model_results <- tibble(
  term = names(coef(retirement_model)),
  estimate = coef(retirement_model),
  std.error = robust_se,
  statistic = estimate / std.error,
  p.value = 2 * pt(abs(statistic), df = retirement_model$df.residual, lower.tail = FALSE)
) %>%
  mutate(
    r.squared = summary(retirement_model)$r.squared,
    adj.r.squared = summary(retirement_model)$adj.r.squared
  )

# Save model and results for paper
saveRDS(list(
  model = retirement_model,
  results = model_results
), "models/retirement_debt_model.rds")


# # Save model results as a text file
# write.table(
#   model_results %>% select(term, estimate, std.error, statistic, p.value),
#   file = "models/both_retirement_model_results.txt",
#   sep = ",",
#   row.names = FALSE,
#   quote = FALSE
# )
