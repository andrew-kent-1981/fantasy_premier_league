# Script name:  dataframe_player_history.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# Player History Data ==========================================================
# This section collates the points scored in each season by each FPL player.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create player list
  df_fpl_players <- df_fpl_players_data[c("id")]
  
  df_fpl_players <- dplyr::distinct(df_fpl_players, 
                                    id, .keep_all = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# This section will loop through each FPL player extracting their data in turn
  df_fpl_player_history_data <- NULL
  df_fpl_player_history_data_temp <- NULL
  
  for (int_active_row in 1:nrow(df_fpl_players)) 
    {
      str_active_player <- df_fpl_players[int_active_row, "id"]
    
      str_variable_link <- paste(str_location_master,
                                 "/fpl_data/",
                                 str_active_season_folder,
                                 "/player_data/",
                                 "lst_fpl_player_data",
                                 "_",
                                 str_active_player,
                                 sep = "")
    
      load(str_variable_link)
    
      df_fpl_player_history_data_temp <- lst_fpl_player_data[["history"]]
    
      df_fpl_player_history_data <- rbind(df_fpl_player_history_data, 
                                          df_fpl_player_history_data_temp)
    
      rm(df_fpl_player_history_data_temp)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data
  rm(str_variable_link,
     int_active_row,
     str_active_player,
     df_fpl_players,
     lst_fpl_player_data)
  
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_player_history_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_player_history_data.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")