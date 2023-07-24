# Script name:  scrape_data.R
# Written by:   Andrew Kent
# Purpose:      This script downloads and backs up all available Fantasy Premier 
#               League data for the current season, ready for use.

# Master Data ==================================================================
  lst_fpl_master_data <- jsonlite::fromJSON("https://fantasy.premierleague.com/api/bootstrap-static/")

  str_file_path <- paste(str_location_master,
                         "/fpl_data/",
                         str_active_season_folder,
                         "/master_data/",
                         "lst_fpl_master_data",
                         sep = "")

  save(lst_fpl_master_data, 
       file = str_file_path)
  
  rm(str_file_path)

# FPL Manager Data =============================================================
  for (i in 1:length(lst_fpl_managers))
  {
    str_active_fpl_manager <- lst_fpl_managers[[i]]
    
    str_variable_link <- paste("https://fantasy.premierleague.com/api/entry/",
                               str_active_fpl_manager,
                               "/", sep = "")
    
    lst_fpl_manager_data <- jsonlite::fromJSON(str_variable_link)
    
    str_file_path <- paste(str_location_master,
                           "/fpl_data/",
                           str_active_season_folder,
                           "/manager_data/",
                           "lst_fpl_manager_data",
                           "_",
                           str_active_fpl_manager,
                           sep = "")
  
    save(lst_fpl_manager_data, 
         file = str_file_path)
  }

  rm(i,
     str_variable_link,
     str_file_path)

# FPL Manager History Data =====================================================
  for (i in 1:length(lst_fpl_managers))
  {
    str_active_fpl_manager <- lst_fpl_managers[[i]]
    
    str_variable_link <- paste("https://fantasy.premierleague.com/api/entry/",
                               str_active_fpl_manager,
                               "/history/",
                               sep = "")
    
    lst_fpl_manager_history_data <- jsonlite::fromJSON(str_variable_link)
  
    str_file_path <- paste(str_location_master,
                           "/fpl_data/",
                           str_active_season_folder,
                           "/manager_data/",
                           "lst_fpl_manager_history_data",
                           "_",
                           str_active_fpl_manager,
                           sep = "")
  
    save(lst_fpl_manager_history_data, 
         file = str_file_path)
  }

  rm(i,
     str_variable_link,
     str_file_path)

# FPL Manager Transfer Data ====================================================
  for (i in 1:length(lst_fpl_managers))
  {
    str_active_fpl_manager <- lst_fpl_managers[[i]]
  
    str_variable_link <- paste("https://fantasy.premierleague.com/api/entry/",
                               str_active_fpl_manager,
                               "/transfers/",
                               sep = "")
  
    lst_fpl_manager_transfers_data <- jsonlite::fromJSON(str_variable_link)
    
    str_file_path <- paste(str_location_master,
                           "/fpl_data/",
                           str_active_season_folder,
                           "/manager_data/",
                           "lst_fpl_manager_transfers_data",
                           "_",
                           str_active_fpl_manager,
                           sep = "")
  
    save(lst_fpl_manager_transfers_data, 
         file = str_file_path)
  }

  rm(i,
     str_variable_link,
     str_file_path)

# FPL Manager Selections Data ==================================================
  for (i in 1:length(lst_fpl_managers))
  {
    str_active_fpl_manager <- lst_fpl_managers[[i]]
    for (i in 1:(int_current_gameweek))
    {
      str_variable_link <- paste("https://fantasy.premierleague.com/api/entry/",
                                 str_active_fpl_manager,
                                 "/event/",
                                 i,
                                 "/picks/", sep = "")
      
      lst_fpl_manager_selections_data <- jsonlite::fromJSON(str_variable_link)

      str_file_path <- paste(str_location_master,
                             "/fpl_data/",
                             str_active_season_folder,
                             "/manager_data/",
                             "lst_fpl_manager_selections_data",
                             "_",
                             str_active_fpl_manager,
                             "_",
                             i,
                             sep = "")

      save(lst_fpl_manager_selections_data,
           file = str_file_path)
    }
  }
  
  rm(i,
     str_variable_link,
     str_file_path)

# FPL Leagues ==================================================================
  str_variable_link <- paste("https://fantasy.premierleague.com/api/leagues-h2h/",
                             str_league_id,
                             "/standings/",
                             sep = "")

  lst_fpl_leagues <- jsonlite::fromJSON(str_variable_link)

  str_file_path <- paste(str_location_master,
                         "/fpl_data/",
                         str_active_season_folder,
                         "/leagues_data/",
                         "lst_fpl_leagues_data",
                         sep = "")

  save(lst_fpl_leagues,
       file = str_file_path)
  
  rm(str_variable_link,
     str_file_path)

# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Information about league with id LID, such as name and standings
# https://fantasy.premierleague.com/api/leagues-classic/LID/standings/

# Page P for leagues LID with more than 50 teams
# https://fantasy.premierleague.com/api/leagues-classic/LID/standings/?page_standings=P
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# FPL Player Data ==============================================================
  df_fpl_player_data  <- lst_fpl_master_data[["elements"]]

  df_fpl_player_data <- df_fpl_player_data[c("id")]

  for (i in 1:nrow(df_fpl_player_data))
  {
    str_active_fpl_player <- df_fpl_player_data[i, "id"]
    str_variable_link <- paste("https://fantasy.premierleague.com/api/element-summary/",
                               str_active_fpl_player,
                               "/",
                               sep = "")
    
    lst_fpl_player_data <- jsonlite::fromJSON(str_variable_link)

    str_file_path <- paste(str_location_master,
                           "/fpl_data/",
                           str_active_season_folder,
                           "/player_data/",
                           "lst_fpl_player_data",
                           "_",
                           str_active_fpl_player,
                           sep = "")

    save(lst_fpl_player_data,
         file = str_file_path)
  }

  rm(i,
     str_variable_link,
     str_file_path)

# FPL Fixtures Data ============================================================
  lst_fpl_fixtures <- jsonlite::fromJSON("https://fantasy.premierleague.com/api/fixtures/")
  
  str_file_path <- paste(str_location_master,
                         "/fpl_data/",
                         str_active_season_folder,
                         "/fixtures_data/",
                         "lst_fpl_fixtures",
                         sep = "")
  
  save(lst_fpl_fixtures,
       file = str_file_path)
  
  rm(str_file_path)

# FPL Live Gameweek Data =======================================================
  for (i in 1:(int_current_gameweek))
  {
    str_variable_link <- paste("https://fantasy.premierleague.com/api/event/",
                                i,
                                "/live/", 
                                sep = "")
    lst_fpl_live_gameweek_data <- jsonlite::fromJSON(str_variable_link)
  
    str_file_path <- paste(str_location_master,
                           "/fpl_data/",
                           str_active_season_folder,
                           "/gameweek_data/",
                           "lst_fpl_live_gameweek_data",
                           "_",
                           i,
                           sep = "")
  
    save(lst_fpl_live_gameweek_data, 
         file = str_file_path)
  }
  
  rm(i,
     str_variable_link,
     str_file_path)

# Clear Variables ==============================================================
# This section clears all variables that are no longer required.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear Data Frames
  rm(df_fpl_player_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear Active Players & Managers
  rm(str_active_fpl_player,
     str_active_fpl_manager)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear Lists
  rm(lst_fpl_fixtures,
     lst_fpl_leagues,
     lst_fpl_live_gameweek_data,
     lst_fpl_manager_data,
     lst_fpl_manager_history_data,
     lst_fpl_manager_selections_data,
     lst_fpl_manager_transfers_data,
     lst_fpl_master_data,
     lst_fpl_player_data)