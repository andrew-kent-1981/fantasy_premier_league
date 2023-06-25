# Script name:  dataframe_ownership.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# Current Ownership Data =======================================================
# This section extracts data relevant to which FPL Manager owns which player
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare the data frames
  df_fpl_ownership_data <- NULL
  df_fpl_ownership_data_temp <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# This section will loop through each FPL manager extracting their data in turn
  for (i in 1:length(lst_fpl_managers))
    {
      str_active_fpl_manager <- lst_fpl_managers[[i]]
      for (i in 1:int_current_gameweek)
        {
          int_active_gameweek <- i
          str_variable_link <- paste(str_location_master,
                                     "/fpl_data/",
                                     str_active_season_folder,
                                     "/manager_data/",
                                     "lst_fpl_manager_selections_data",
                                     "_",
                                     str_active_fpl_manager,
                                     "_",
                                     int_active_gameweek,
                                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#         Create FPL ownership list
          load(str_variable_link)
          lst_fpl_ownership_data <- lst_fpl_manager_selections_data
            rm(lst_fpl_manager_selections_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#         Convert the list data into a data frame
          df_fpl_ownership_data_temp <- lst_fpl_ownership_data[["picks"]]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#         Add the active FPL Manager ID to the data frame
          df_fpl_ownership_data_temp$id <- str_active_fpl_manager
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#         Add the active gameweek to the data frame
          df_fpl_ownership_data_temp$gameweek <- int_active_gameweek
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#         Bind the extracted data into the master list of FPL ownership data before
#         repeating the process
          df_fpl_ownership_data <- rbind(df_fpl_ownership_data, 
                                          df_fpl_ownership_data_temp)
          rm(df_fpl_ownership_data_temp)
        }
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no longer required
  rm(i,
     str_variable_link,
     str_active_fpl_manager,
     int_active_gameweek,
     lst_fpl_ownership_data)

# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_ownership_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_ownership_data.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")