# Script name:  dataframe_teams.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# Team Data ====================================================================
# This section extracts data relevant to each premier league team
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Access FPL Data
  str_variable_link <- paste(str_location_master,
                             "/fpl_data/",
                             str_active_season_folder,
                             "/master_data/",
                             "lst_fpl_master_data",
                             sep = "")
  
  load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return the Events table
  df_fpl_teams_data <- lst_fpl_master_data[["teams"]]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no longer required
  rm(str_variable_link,
     lst_fpl_master_data)
  
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_teams_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_teams_data.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")
