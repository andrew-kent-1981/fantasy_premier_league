# Script name:  packages.R
# Written by:   Andrew Kent
# Purpose:      Ensure that all packages that are required within the project
#               are loaded.

# Load packages ================================================================
# These packages are used within the data model. The load order is based on when
# they are first used.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Foundation packages (data structures and performance utilities).
  library(data.table, warn.conflicts = FALSE)   # High-performance data manipulation
  library(tibble, warn.conflicts = FALSE)       # Modern data frame handling
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Specialized functionality (dates, strings, and time-series).
  library(lubridate, warn.conflicts = FALSE)    # Date/time handling
  library(stringr, warn.conflicts = FALSE)      # String manipulation
  library(zoo, warn.conflicts = FALSE)          # Time series and rolling calculations
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# File I/O (read/write external data sources).
  library(readxl, warn.conflicts = FALSE)       # Read Excel files
  library(writexl, warn.conflicts = FALSE)      # Write Excel files
  library(odbc, warn.conflicts = FALSE)         # Database connections
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Core data manipulation and analysis tools.
  library(dplyr, warn.conflicts = FALSE)        # Data wrangling
  library(tidyverse, warn.conflicts = FALSE)    # Collection of data manipulation tools
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Visualization and reporting.
library(blastula, warn.conflicts = FALSE)     # Email reporting
