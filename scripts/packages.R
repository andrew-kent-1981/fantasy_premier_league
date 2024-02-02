# Script name:  packages.R
# Written by:   Andrew Kent
# Purpose:      Ensure that all packages that are required within the project
#               are loaded.

# Load packages ================================================================
  library(odbc, warn.conflicts = FALSE)
  library(lubridate, warn.conflicts = FALSE)
  library(data.table, warn.conflicts = FALSE)
  library(dplyr, warn.conflicts = FALSE)
  library(stringr, warn.conflicts = FALSE)
  library(tidyr, warn.conflicts = FALSE)
  library(rstudioapi, warn.conflicts = FALSE)
  library(readxl, warn.conflicts = FALSE)
  library(writexl, warn.conflicts = FALSE)