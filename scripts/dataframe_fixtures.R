# Script name:  dataframe_fixtures.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# FPL Fixture Data =============================================================
# This section extracts data relevant to each FPL fixture
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  str_variable_link <- paste(str_location_master,
                             "/fpl_data/",
                             str_active_season_folder,
                             "/fixtures_data/",
                             "lst_fpl_fixtures",
                             sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create FPL fixture list
  load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove all fields that are not required
  lst_fpl_fixtures$stats <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create data frame
  df_fpl_fixtures_data <- lst_fpl_fixtures
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no longer required
  rm(str_variable_link,
     lst_fpl_fixtures)
  
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_fixtures_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_fixtures_data.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")
