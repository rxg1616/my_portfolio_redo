# ============================================================
# Garmin Dive Data - Data Wrangling
# ============================================================
#
# Author: Rileigh Gonzalez
# Project: EVR 628 - Fall 2026
# Purpose: Import, clean, and export Garmin dive activity data

# 1. Load Required Libraries
library(tidyverse)
library(janitor)

# 2. Import the Garmin CSV
raw_dive_data <- readr::read_csv(
  "scripts/01_processing/Activities (2).csv"
)

# 3. Clean column names
raw_dive_data <- raw_dive_data %>%
  clean_names()

# Check column names
names(raw_dive_data)

# 4. Clean and standardize data
cleaned_dive_data <- raw_dive_data %>%

  # Filter out non-dive activities
  filter(
    str_detect(activity_type, regex("dive", ignore_case = TRUE))
  ) %>%

  # Standardize data
  mutate(
    date = as.Date(date),
    max_depth_num = as.numeric(
      str_remove_all(max_depth, "[^0-9.]")
    )
  ) %>%

  # Remove duplicate rows
  distinct() %>%

  # Remove empty rows and columns
  remove_empty(c("rows", "cols"))

# 5. View clean dataset
glimpse(cleaned_dive_data)

# 6. Export cleaned data
write_csv(
  cleaned_dive_data,
  "cleaned_garmin_dives.csv"
)

