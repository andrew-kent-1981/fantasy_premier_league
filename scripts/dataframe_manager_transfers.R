# Script name:  dataframe_manager_transfers.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# FPL Transfer Data ============================================================
# This section extracts data relevant to each FPL transfer
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare the data frames
  df_fpl_manager_transfers_data <- NULL
  df_fpl_manager_transfers_data_data_temp <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# This section will loop through each FPL manager extracting their data in turn
  for (i in 1:length(lst_fpl_managers))
    {
      str_active_fpl_manager <- lst_fpl_managers[[i]]
      
      str_variable_link <- paste(str_location_master,
                                 "/fpl_data/",
                                 str_active_season_folder,
                                 "/manager_data/",
                                 "lst_fpl_manager_transfers_data",
                                 "_",
                                 str_active_fpl_manager,
                                 sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Create FPL transfer list
      load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Convert the list data into a data frame
      switch(length(lst_fpl_manager_transfers_data) == 0,
             df_fpl_manager_transfers_data_data_temp <-
               data.frame(element_in = NA,
                          element_in_cost = NA,
                          element_out = NA,
                          element_out_cost = NA,
                          entry = str_active_fpl_manager,
                          event = NA,
                          time = NA),
             NULL)
      
      switch(length(lst_fpl_manager_transfers_data) != 0,
             df_fpl_manager_transfers_data_data_temp <- lst_fpl_manager_transfers_data,
             NULL)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Bind the extracted data into the master list of FPL ownership data before
#     repeating the process
      df_fpl_manager_transfers_data <- rbind(df_fpl_manager_transfers_data, 
                                             df_fpl_manager_transfers_data_data_temp)
      
      rm(df_fpl_manager_transfers_data_data_temp)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no loner required
  rm(i,
     str_variable_link,
     str_active_fpl_manager,
     lst_fpl_manager_transfers_data)
      
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_manager_transfers_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_manager_transfers_data.csv", sep=""),
              row.names = FALSE,
              col.names = TRUE,
              na = "",
              sep = ",")