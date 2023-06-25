# Script name:  upload_data.R
# Written by:   Andrew Kent
# Purpose:      This script combines the current season with previous seasons 
#               and uploads the data to the database.

# Extract Data =================================================================
# This section extracts each .csv file and combines them into one data frame
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_managers_data
  df_fpl_managers_data <- NULL
  df_fpl_managers_data_temp <- NULL

  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
    
      df_fpl_managers_data_temp <- read.csv(paste(str_location_master,
                                                  "/backup_data/",
                                                  str_active_upload_season,
                                                  "/",
                                                  "fpl_managers_data.csv", 
                                                  sep = ""), 
                                             header = TRUE,
                                             sep = ",",
                                             na.strings = c("","NA"))
      
      df_fpl_managers_data_temp$season_name <- paste("20",
                                                     str_sub(str_active_upload_season, start = 8,  end = 9),
                                                     "/",
                                                     str_sub(str_active_upload_season, start = 11,  end = 12),
                                                     sep = "")
      
      df_fpl_managers_data <- plyr::rbind.fill(df_fpl_managers_data, 
                                               df_fpl_managers_data_temp)
      
      rm(df_fpl_managers_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_managers_data$joined_time <- ymd_hms(df_fpl_managers_data$joined_time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_manager_current_season_data
  df_fpl_manager_current_season_data <- NULL
  df_fpl_manager_current_season_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_manager_current_season_data_temp <- read.csv(paste(str_location_master,
                                                                "/backup_data/",
                                                                str_active_upload_season,
                                                                "/",
                                                                "fpl_manager_current_season_data.csv", 
                                                                sep = ""), 
                                                          header = TRUE,
                                                          sep = ",",
                                                          na.strings = c("","NA"))
      
      df_fpl_manager_current_season_data_temp$season_name <- paste("20",
                                                                   str_sub(str_active_upload_season, start = 8,  end = 9),
                                                                   "/",
                                                                   str_sub(str_active_upload_season, start = 11,  end = 12),
                                                                   sep = "")
      
      df_fpl_manager_current_season_data <- plyr::rbind.fill(df_fpl_manager_current_season_data, 
                                                             df_fpl_manager_current_season_data_temp)
      
      rm(df_fpl_manager_current_season_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_manager_transfers_data
  df_fpl_manager_transfers_data <- NULL
  df_fpl_manager_transfers_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_manager_transfers_data_temp <- read.csv(paste(str_location_master,
                                                           "/backup_data/",
                                                           str_active_upload_season,
                                                           "/",
                                                           "fpl_manager_transfers_data.csv", 
                                                           sep = ""), 
                                                     header = TRUE,
                                                     sep = ",",
                                                     na.strings = c("","NA"))
      
      df_fpl_manager_transfers_data_temp$season_name <- paste("20",
                                                              str_sub(str_active_upload_season, start = 8,  end = 9),
                                                              "/",
                                                              str_sub(str_active_upload_season, start = 11,  end = 12),
                                                              sep = "")
      
      df_fpl_manager_transfers_data <- plyr::rbind.fill(df_fpl_manager_transfers_data, 
                                                        df_fpl_manager_transfers_data_temp)
      
      rm(df_fpl_manager_transfers_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_manager_transfers_data$time <- ymd_hms(df_fpl_manager_transfers_data$time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_manager_chips_data
  df_fpl_manager_chips_data <- NULL
  df_fpl_manager_chips_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_manager_chips_data_temp <- read.csv(paste(str_location_master,
                                                       "/backup_data/",
                                                       str_active_upload_season,
                                                       "/",
                                                       "fpl_manager_chips_data.csv", 
                                                       sep = ""), 
                                                 header = TRUE,
                                                 sep = ",",
                                                 na.strings = c("","NA"))
      
      df_fpl_manager_chips_data_temp$season_name <- paste("20",
                                                          str_sub(str_active_upload_season, start = 8,  end = 9),
                                                          "/",
                                                          str_sub(str_active_upload_season, start = 11,  end = 12),
                                                          sep = "")
      
      df_fpl_manager_chips_data <- plyr::rbind.fill(df_fpl_manager_chips_data, 
                                                    df_fpl_manager_chips_data_temp)
      
      rm(df_fpl_manager_chips_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_manager_chips_data$time <- ymd_hms(df_fpl_manager_chips_data$time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_manager_history_data
  df_fpl_manager_history_data <- NULL
  df_fpl_manager_history_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_manager_history_data_temp <- read.csv(paste(str_location_master,
                                                         "/backup_data/",
                                                         str_active_upload_season,
                                                         "/",
                                                         "fpl_manager_history_data.csv", 
                                                         sep = ""), 
                                                   header = TRUE,
                                                   sep = ",",
                                                   na.strings = c("","NA"))
      
      df_fpl_manager_history_data <- plyr::rbind.fill(df_fpl_manager_history_data, 
                                                      df_fpl_manager_history_data_temp)
      
      rm(df_fpl_manager_history_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_fixtures_data
  df_fpl_fixtures_data <- NULL
  df_fpl_fixtures_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_fixtures_data_temp <- read.csv(paste(str_location_master,
                                                  "/backup_data/",
                                                  str_active_upload_season,
                                                  "/",
                                                  "fpl_fixtures_data.csv", 
                                                  sep = ""), 
                                            header = TRUE,
                                            sep = ",",
                                            na.strings = c("","NA"))
      
      df_fpl_fixtures_data_temp$season_name <- paste("20",
                                                     str_sub(str_active_upload_season, start = 8,  end = 9),
                                                     "/",
                                                     str_sub(str_active_upload_season, start = 11,  end = 12),
                                                     sep = "")
      
      df_fpl_fixtures_data <- plyr::rbind.fill(df_fpl_fixtures_data, 
                                               df_fpl_fixtures_data_temp)
      
      rm(df_fpl_fixtures_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_fixtures_data$kickoff_time <- ymd_hms(df_fpl_fixtures_data$kickoff_time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_teams_data
  df_fpl_teams_data <- NULL
  df_fpl_teams_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_teams_data_temp <- read.csv(paste(str_location_master,
                                               "/backup_data/",
                                               str_active_upload_season,
                                               "/",
                                               "fpl_teams_data.csv", 
                                               sep = ""), 
                                         header = TRUE,
                                         sep = ",",
                                         na.strings = c("","NA"))
      
      df_fpl_teams_data_temp$season_name <- paste("20",
                                                  str_sub(str_active_upload_season, start = 8,  end = 9),
                                                  "/",
                                                  str_sub(str_active_upload_season, start = 11,  end = 12),
                                                  sep = "")
      
      df_fpl_teams_data <- plyr::rbind.fill(df_fpl_teams_data, 
                                            df_fpl_teams_data_temp)
      
      rm(df_fpl_teams_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_players_data
  df_fpl_players_data <- NULL
  df_fpl_players_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_players_data_temp <- read.csv(paste(str_location_master,
                                                 "/backup_data/",
                                                 str_active_upload_season,
                                                 "/",
                                                 "fpl_players_data.csv", 
                                                 sep = ""), 
                                           header = TRUE,
                                           sep = ",",
                                           na.strings = c("","NA"))
      
      df_fpl_players_data_temp$season_name <- paste("20",
                                                    str_sub(str_active_upload_season, start = 8,  end = 9),
                                                    "/",
                                                    str_sub(str_active_upload_season, start = 11,  end = 12),
                                                    sep = "")
      
      df_fpl_players_data <- plyr::rbind.fill(df_fpl_players_data, 
                                              df_fpl_players_data_temp)
      
      rm(df_fpl_players_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_players_data$news_added <- ymd_hms(df_fpl_players_data$news_added)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_player_types_data
  df_fpl_player_types_data <- NULL
  df_fpl_player_types_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_player_types_data_temp <- read.csv(paste(str_location_master,
                                                      "/backup_data/",
                                                      str_active_upload_season,
                                                      "/",
                                                      "fpl_player_types_data.csv", 
                                                      sep = ""), 
                                                header = TRUE,
                                                sep = ",",
                                                na.strings = c("","NA"))
      
      df_fpl_player_types_data_temp$season_name <- paste("20",
                                                         str_sub(str_active_upload_season, start = 8,  end = 9),
                                                         "/",
                                                         str_sub(str_active_upload_season, start = 11,  end = 12),
                                                         sep = "")
      
      df_fpl_player_types_data <- plyr::rbind.fill(df_fpl_player_types_data, 
                                                   df_fpl_player_types_data_temp)
      
      rm(df_fpl_player_types_data_temp)
      
  }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_player_history_data
  df_fpl_player_history_data <- NULL
  df_fpl_player_history_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_player_history_data_temp <- read.csv(paste(str_location_master,
                                                        "/backup_data/",
                                                        str_active_upload_season,
                                                        "/",
                                                        "fpl_player_history_data.csv", 
                                                        sep = ""), 
                                                  header = TRUE,
                                                  sep = ",",
                                                  na.strings = c("","NA"))
      
      df_fpl_player_history_data_temp$season_name <- paste("20",
                                                           str_sub(str_active_upload_season, start = 8,  end = 9),
                                                           "/",
                                                           str_sub(str_active_upload_season, start = 11,  end = 12),
                                                           sep = "")
      
      df_fpl_player_history_data <- plyr::rbind.fill(df_fpl_player_history_data, 
                                                     df_fpl_player_history_data_temp)
      
      rm(df_fpl_player_history_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct date variables
  df_fpl_player_history_data$kickoff_time <- ymd_hms(df_fpl_player_history_data$kickoff_time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_gameweeks_data
  df_fpl_gameweeks_data <- NULL
  df_fpl_gameweeks_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_gameweeks_data_temp <- read.csv(paste(str_location_master,
                                                   "/backup_data/",
                                                   str_active_upload_season,
                                                   "/",
                                                   "fpl_gameweeks_data.csv", 
                                                   sep = ""), 
                                             header = TRUE,
                                             sep = ",",
                                             na.strings = c("","NA"))
      
      df_fpl_gameweeks_data_temp$season_name <- paste("20",
                                                      str_sub(str_active_upload_season, start = 8,  end = 9),
                                                      "/",
                                                      str_sub(str_active_upload_season, start = 11,  end = 12),
                                                      sep = "")
      
      df_fpl_gameweeks_data <- plyr::rbind.fill(df_fpl_gameweeks_data, 
                                                df_fpl_gameweeks_data_temp)
      
      rm(df_fpl_gameweeks_data_temp)
      
    }
  rm(i)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# df_fpl_ownership_data
  df_fpl_ownership_data <- NULL
  df_fpl_ownership_data_temp <- NULL
  
  for (i in 1:length(lst_season_list))
    {
      str_active_upload_season <- lst_season_list[[i]]
      
      df_fpl_ownership_data_temp <- read.csv(paste(str_location_master,
                                                   "/backup_data/",
                                                   str_active_upload_season,
                                                   "/",
                                                   "fpl_ownership_data.csv", 
                                                   sep = ""), 
                                             header = TRUE,
                                             sep = ",",
                                             na.strings = c("","NA"))
      
      df_fpl_ownership_data_temp$season_name <- paste("20",
                                                      str_sub(str_active_upload_season, start = 8,  end = 9),
                                                      "/",
                                                      str_sub(str_active_upload_season, start = 11,  end = 12),
                                                      sep = "")
      
      df_fpl_ownership_data <- plyr::rbind.fill(df_fpl_ownership_data, 
                                                df_fpl_ownership_data_temp)
      
      rm(df_fpl_ownership_data_temp)
      
    }
  rm(i)
  
# Upload Data ==================================================================
# This section takes the completed data model and uploads to the data base for
# use within future analysis
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Connect to database
  db_connection_cod <- DBI::dbConnect(odbc::odbc(),
                                      Driver = "{SQL Server}",
                                      Server = str_cod_server,
                                      Database = str_cod_database,
                                      UID = str_cod_db_userid,
                                      PWD = str_cod_db_password)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_managers_data
  dbWriteTable(db_connection_cod,
               "fpl_managers_data",
               df_fpl_managers_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(id = 'decimal(9, 0)',
                               joined_time = 'datetime',
                               started_event = 'decimal(9, 0)',
                               player_first_name = 'nvarchar(255)',
                               player_last_name = 'nvarchar(255)',
                               player_region_id = 'decimal(9, 0)',
                               player_region_name = 'nvarchar(255)',
                               player_iso_code_short = 'nvarchar(255)',
                               player_iso_code_long = 'nvarchar(255)',
                               summary_overall_points = 'decimal(9, 0)',
                               summary_overall_rank = 'decimal(9, 0)',
                               summary_event_points = 'decimal(9, 0)',
                               summary_event_rank = 'decimal(9, 0)',
                               current_event = 'decimal(9, 0)',
                               name = 'nvarchar(255)',
                               last_deadline_bank = 'decimal(9, 0)',
                               last_deadline_value = 'decimal(9, 0)',
                               last_deadline_total_transfers = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_managers_data
  dbWriteTable(db_connection_cod,
               "fpl_manager_current_season_data",
               df_fpl_manager_current_season_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(event = 'decimal(9, 0)',
                               points = 'decimal(9, 0)',
                               total_points = 'decimal(9, 0)',
                               rank = 'decimal(9, 0)',
                               rank_sort = 'decimal(9, 0)',
                               overall_rank = 'decimal(9, 0)',
                               bank = 'decimal(9, 0)',
                               value = 'decimal(9, 0)',
                               event_transfers = 'decimal(9, 0)',
                               event_transfers_cost = 'decimal(9, 0)',
                               points_on_bench = 'decimal(9, 0)',
                               id = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_manager_transfers_data
  dbWriteTable(db_connection_cod,
               "fpl_manager_transfers_data",
               df_fpl_manager_transfers_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(element_in = 'decimal(9, 0)',
                               element_in_cost = 'decimal(9, 0)',
                               element_out = 'decimal(9, 0)',
                               element_out_cost = 'decimal(9, 0)',
                               entry = 'decimal(9, 0)',
                               event = 'decimal(9, 0)',
                               time = 'datetime',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_manager_chips_data
  dbWriteTable(db_connection_cod,
               "fpl_manager_chips_data",
               df_fpl_manager_chips_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(name = 'nvarchar(255)',
                               time = 'datetime',
                               event = 'decimal(9, 0)',
                               id = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_manager_history_data
  dbWriteTable(db_connection_cod,
               "fpl_manager_history_data",
               df_fpl_manager_history_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(season_name = 'nvarchar(255)',
                               total_points = 'decimal(9, 0)',
                               rank = 'decimal(9, 0)',
                               id = 'decimal(9, 0)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_fixtures_data
  dbWriteTable(db_connection_cod,
               "fpl_fixtures_data",
               df_fpl_fixtures_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(code = 'decimal(9, 0)',
                               event = 'decimal(9, 0)',
                               finished = 'nvarchar(255)',
                               finished_provisional = 'nvarchar(255)',
                               id = 'decimal(9, 0)',
                               kickoff_time = 'datetime',
                               minutes = 'decimal(9, 0)',
                               provisional_start_time = 'nvarchar(255)',
                               started = 'nvarchar(255)',
                               team_a = 'decimal(9, 0)',
                               team_a_score = 'decimal(9, 0)',
                               team_h = 'decimal(9, 0)',
                               team_h_score = 'decimal(9, 0)',
                               team_h_difficulty = 'decimal(9, 0)',
                               team_a_difficulty = 'decimal(9, 0)',
                               pulse_id = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_teams_data
  dbWriteTable(db_connection_cod,
               "fpl_teams_data",
               df_fpl_teams_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(code = 'decimal(9, 0)',
                               draw = 'decimal(9, 0)',
                               form = 'decimal(9, 0)',
                               id = 'decimal(9, 0)',
                               loss = 'decimal(9, 0)',
                               name = 'nvarchar(255)',
                               played = 'decimal(9, 0)',
                               points = 'decimal(9, 0)',
                               position = 'decimal(9, 0)',
                               short_name = 'nvarchar(255)',
                               strength = 'decimal(9, 0)',
                               team_division = 'decimal(9, 0)',
                               unavailable = 'nvarchar(255)',
                               win = 'decimal(9, 0)',
                               strength_overall_home = 'decimal(9, 0)',
                               strength_overall_away = 'decimal(9, 0)',
                               strength_attack_home = 'decimal(9, 0)',
                               strength_attack_away = 'decimal(9, 0)',
                               strength_defence_home = 'decimal(9, 0)',
                               strength_defence_away = 'decimal(9, 0)',
                               pulse_id = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_players_data
  dbWriteTable(db_connection_cod,
               "fpl_players_data",
               df_fpl_players_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(chance_of_playing_next_round = 'decimal(9, 0)',
                               chance_of_playing_this_round = 'decimal(9, 0)',
                               code = 'decimal(9, 0)',
                               cost_change_event = 'decimal(9, 0)',
                               cost_change_event_fall = 'decimal(9, 0)',
                               cost_change_start = 'decimal(9, 0)',
                               cost_change_start_fall = 'decimal(9, 0)',
                               dreamteam_count = 'decimal(9, 0)',
                               element_type = 'decimal(9, 0)',
                               ep_next = 'decimal(18, 4)',
                               ep_this = 'decimal(18, 4)',
                               event_points = 'decimal(9, 0)',
                               first_name = 'nvarchar(255)',
                               form = 'decimal(18, 4)',
                               id = 'decimal(9, 0)',
                               in_dreamteam = 'nvarchar(255)',
                               news = 'nvarchar(255)',
                               news_added = 'datetime',
                               now_cost = 'decimal(9, 0)',
                               photo = 'nvarchar(255)',
                               points_per_game = 'decimal(18, 4)',
                               second_name = 'nvarchar(255)',
                               selected_by_percent = 'decimal(18, 4)',
                               special = 'nvarchar(255)',
                               squad_number = 'decimal(9, 0)',
                               status = 'nvarchar(255)',
                               team = 'nvarchar(255)',
                               team_code = 'decimal(9, 0)',
                               total_points = 'decimal(9, 0)',
                               transfers_in = 'decimal(9, 0)',
                               transfers_in_event = 'decimal(9, 0)',
                               transfers_out = 'decimal(9, 0)',
                               transfers_out_event = 'decimal(9, 0)',
                               value_form = 'decimal(18, 4)',
                               value_season = 'decimal(18, 4)',
                               web_name = 'nvarchar(255)',
                               minutes = 'decimal(9, 0)',
                               goals_scored = 'decimal(9, 0)',
                               assists = 'decimal(9, 0)',
                               clean_sheets = 'decimal(9, 0)',
                               goals_conceded = 'decimal(9, 0)',
                               own_goals = 'decimal(9, 0)',
                               penalties_saved = 'decimal(9, 0)',
                               penalties_missed = 'decimal(9, 0)',
                               yellow_cards = 'decimal(9, 0)',
                               red_cards = 'decimal(9, 0)',
                               saves = 'decimal(9, 0)',
                               bonus = 'decimal(9, 0)',
                               bps = 'decimal(9, 0)',
                               influence = 'decimal(18, 4)',
                               creativity = 'decimal(18, 4)',
                               threat = 'decimal(18, 4)',
                               ict_index = 'decimal(18, 4)',
                               starts = 'decimal(9, 0)',
                               expected_goals = 'decimal(18, 4)',
                               expected_assists = 'decimal(18, 4)',
                               expected_goal_involvements = 'decimal(18, 4)',
                               expected_goals_conceded = 'decimal(18, 4)',
                               influence_rank = 'decimal(9, 0)',
                               influence_rank_type = 'decimal(9, 0)',
                               creativity_rank = 'decimal(9, 0)',
                               creativity_rank_type = 'decimal(9, 0)',
                               threat_rank = 'decimal(9, 0)',
                               threat_rank_type = 'decimal(9, 0)',
                               ict_index_rank = 'decimal(9, 0)',
                               ict_index_rank_type = 'decimal(9, 0)',
                               corners_and_indirect_freekicks_order = 'decimal(9, 0)',
                               corners_and_indirect_freekicks_text = 'decimal(9, 0)',
                               direct_freekicks_order = 'decimal(9, 0)',
                               direct_freekicks_text = 'decimal(9, 0)',
                               penalties_order = 'decimal(9, 0)',
                               penalties_text = 'nvarchar(255)',
                               expected_goals_per_90 = 'decimal(18, 4)',
                               saves_per_90 = 'decimal(18, 4)',
                               expected_assists_per_90 = 'decimal(18, 4)',
                               expected_goal_involvements_per_90 = 'decimal(18, 4)',
                               expected_goals_conceded_per_90 = 'decimal(18, 4)',
                               goals_conceded_per_90 = 'decimal(18, 4)',
                               now_cost_rank = 'decimal(9, 0)',
                               now_cost_rank_type = 'decimal(9, 0)',
                               form_rank = 'decimal(9, 0)',
                               form_rank_type = 'decimal(9, 0)',
                               points_per_game_rank = 'decimal(9, 0)',
                               points_per_game_rank_type = 'decimal(9, 0)',
                               selected_rank = 'decimal(9, 0)',
                               selected_rank_type = 'decimal(9, 0)',
                               starts_per_90 = 'decimal(18, 4)',
                               clean_sheets_per_90 = 'decimal(18, 4)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_player_types_data
  dbWriteTable(db_connection_cod,
               "fpl_player_types_data",
               df_fpl_player_types_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(id = 'decimal(9, 0)',
                               plural_name = 'nvarchar(255)',
                               plural_name_short = 'nvarchar(255)',
                               singular_name = 'nvarchar(255)',
                               singular_name_short = 'nvarchar(255)',
                               squad_select = 'decimal(9, 0)',
                               squad_min_play = 'decimal(9, 0)',
                               squad_max_play = 'decimal(9, 0)',
                               ui_shirt_specific = 'nvarchar(255)',
                               element_count = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_player_history_data
  dbWriteTable(db_connection_cod,
               "fpl_player_history_data",
               df_fpl_player_history_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(element = 'decimal(9, 0)',
                               fixture = 'decimal(9, 0)',
                               opponent_team = 'decimal(9, 0)',
                               total_points = 'decimal(9, 0)',
                               was_home = 'nvarchar(255)',
                               kickoff_time = 'datetime',
                               team_h_score = 'decimal(9, 0)',
                               team_a_score = 'decimal(9, 0)',
                               round = 'decimal(9, 0)',
                               minutes = 'decimal(9, 0)',
                               goals_scored = 'decimal(9, 0)',
                               assists = 'decimal(9, 0)',
                               clean_sheets = 'decimal(9, 0)',
                               goals_conceded = 'decimal(9, 0)',
                               own_goals = 'decimal(9, 0)',
                               penalties_saved = 'decimal(9, 0)',
                               penalties_missed = 'decimal(9, 0)',
                               yellow_cards = 'decimal(9, 0)',
                               red_cards = 'decimal(9, 0)',
                               saves = 'decimal(9, 0)',
                               bonus = 'decimal(9, 0)',
                               bps = 'decimal(9, 0)',
                               influence = 'decimal(18, 4)',
                               creativity = 'decimal(18, 4)',
                               threat = 'decimal(18, 4)',
                               ict_index = 'decimal(18, 4)',
                               starts = 'decimal(9, 0)',
                               expected_goals = 'decimal(18, 4)',
                               expected_assists = 'decimal(18, 4)',
                               expected_goal_involvements = 'decimal(18, 4)',
                               expected_goals_conceded = 'decimal(18, 4)',
                               value = 'decimal(9, 0)',
                               transfers_balance = 'decimal(9, 0)',
                               selected = 'decimal(9, 0)',
                               transfers_in = 'decimal(9, 0)',
                               transfers_out = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_gameweeks_data
  dbWriteTable(db_connection_cod,
               "fpl_gameweeks_data",
               df_fpl_gameweeks_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(player_id = 'decimal(9, 0)',
                               minutes = 'decimal(9, 0)',
                               goals_scored = 'decimal(9, 0)',
                               assists = 'decimal(9, 0)',
                               clean_sheets = 'decimal(9, 0)',
                               goals_conceded = 'decimal(9, 0)',
                               own_goals = 'decimal(9, 0)',
                               penalties_saved = 'decimal(9, 0)',
                               penalties_missed = 'decimal(9, 0)',
                               yellow_cards = 'decimal(9, 0)',
                               red_cards = 'decimal(9, 0)',
                               saves = 'decimal(9, 0)',
                               bonus = 'decimal(9, 0)',
                               bps = 'decimal(9, 0)',
                               influence = 'decimal(18, 4)',
                               creativity = 'decimal(18, 4)',
                               threat = 'decimal(18, 4)',
                               ict_index = 'decimal(18, 4)',
                               starts = 'decimal(9, 0)',
                               expected_goals = 'decimal(18, 4)',
                               expected_assists = 'decimal(18, 4)',
                               expected_goal_involvements = 'decimal(18, 4)',
                               expected_goals_conceded = 'decimal(18, 4)',
                               total_points = 'decimal(9, 0)',
                               in_dreamteam = 'nvarchar(255)',
                               gameweek = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data - df_fpl_ownership_data
  dbWriteTable(db_connection_cod,
               "fpl_ownership_data",
               df_fpl_ownership_data,
               append = FALSE,
               overwrite = TRUE,
               batch_rows = 10000,
               field.types = c(element = 'decimal(9, 0)',
                               position = 'decimal(9, 0)',
                               multiplier = 'decimal(9, 0)',
                               is_captain = 'nvarchar(255)',
                               is_vice_captain = 'nvarchar(255)',
                               id = 'decimal(9, 0)',
                               gameweek = 'decimal(9, 0)',
                               season_name = 'nvarchar(255)'))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Disconnect from database
  dbDisconnect(db_connection_cod)
  
  rm(db_connection_cod)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear completed data frames
  rm(df_fpl_managers_data,
     df_fpl_manager_current_season_data,
     df_fpl_manager_transfers_data,
     df_fpl_manager_chips_data,
     df_fpl_manager_history_data,
     df_fpl_fixtures_data,
     df_fpl_teams_data,
     df_fpl_players_data,
     df_fpl_player_types_data,
     df_fpl_player_history_data,
     df_fpl_gameweeks_data,
     df_fpl_ownership_data)