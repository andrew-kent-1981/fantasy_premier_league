# Script name:  dataframe_manager_chips.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# FPL Manager Data =============================================================
# This section extracts data relevant to each FPL manager
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare the data frames
  df_fpl_manager_chips_data <- NULL
  df_fpl_manager_chips_temp <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# This section will loop through each FPL manager extracting their data in turn
  for (i in 1:length(lst_fpl_managers))
    {
      str_active_fpl_manager <- lst_fpl_managers[[i]]
      
      str_variable_link <- paste(str_location_master,
                                 "/fpl_data/",
                                 str_active_season_folder,
                                 "/manager_data/",
                                 "lst_fpl_manager_history_data",
                                 "_",
                                 str_active_fpl_manager,
                                 sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Create FPL entry list
      load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Return the Current table
      df_fpl_manager_chips_temp <- lst_fpl_manager_history_data[["chips"]]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Rename fields
      df_fpl_manager_chips_temp <- data.frame(setNames(df_fpl_manager_chips_temp,
                                                       c("name",
                                                         "time",
                                                         "event")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Add manager id
      df_fpl_manager_chips_temp$id <- str_active_fpl_manager
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Bind the extracted data into the master list of FPL Manager data before
#     repeating the process
      df_fpl_manager_chips_data <- rbind(df_fpl_manager_chips_data,
                                         df_fpl_manager_chips_temp)
      rm(df_fpl_manager_chips_temp)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no loner required
  rm(i,
     str_variable_link,
     str_active_fpl_manager,
     lst_fpl_manager_history_data)

# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_manager_chips_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_manager_chips_data.csv", sep=""),
              row.names = FALSE,
              col.names = TRUE,
              na = "",
              sep = ",")