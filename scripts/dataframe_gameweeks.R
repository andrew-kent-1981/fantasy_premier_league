# Script name:  dataframe_gameweeks.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# Game Week Data ===============================================================
# This section extracts game week data for each Fantasy Premier League asset
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Extract the Fantasy Premier League game week data
  df_fpl_gameweeks_data <- NULL
  df_fpl_gameweeks_data_temp <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  for (i in 1:(int_current_gameweek))
    {
      str_variable_link <- paste(str_location_master,
                                 "/fpl_data/",
                                 str_active_season_folder,
                                 "/gameweek_data/",
                                 "lst_fpl_live_gameweek_data",
                                 "_",
                                 i,
                                 sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Create FPL entry list
      load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Extract player data
      df_fpl_gameweeks_data_temp <- lst_fpl_live_gameweek_data[["elements"]]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Remove fields that are not needed
      df_fpl_gameweeks_data_temp$explain <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Convert list into a data frame
      df_fpl_gameweeks_data_temp <- as.data.frame(matrix(unlist(df_fpl_gameweeks_data_temp), nrow=length(unlist(df_fpl_gameweeks_data_temp[1]))))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Rename fields
      df_fpl_gameweeks_data_temp <- data.frame(setNames(df_fpl_gameweeks_data_temp,
                                                        c("player_id",
                                                          "minutes",
                                                          "goals_scored",
                                                          "assists",
                                                          "clean_sheets",
                                                          "goals_conceded",
                                                          "own_goals",
                                                          "penalties_saved",
                                                          "penalties_missed",
                                                          "yellow_cards",
                                                          "red_cards",
                                                          "saves",
                                                          "bonus",
                                                          "bps",
                                                          "influence",
                                                          "creativity",
                                                          "threat",
                                                          "ict_index",
                                                          "starts",
                                                          "expected_goals",
                                                          "expected_assists",
                                                          "expected_goal_involvements",
                                                          "expected_goals_conceded",
                                                          "total_points",
                                                          "in_dreamteam")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Add the game week to the data frame
      df_fpl_gameweeks_data_temp$gameweek <- i
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Bind the data into the master data frame
      df_fpl_gameweeks_data <- rbind(df_fpl_gameweeks_data, 
                                    df_fpl_gameweeks_data_temp)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Remove the temporary data frame
      rm(df_fpl_gameweeks_data_temp)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  rm(i,
     str_variable_link,
     lst_fpl_live_gameweek_data)
      
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_gameweeks_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_gameweeks_data.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")
