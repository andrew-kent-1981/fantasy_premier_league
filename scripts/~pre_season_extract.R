# Script name:  ~pre_season_extract.R
# Written by:   Andrew Kent
# Purpose:      This script is used to extract data that is used within the
#               pre-season planning process and is a trimmed down version of the
#               full extract routine

# Procedure Start ==============================================================
  dat_start_time <- Sys.time()

# Load variables & Packages ====================================================
# This section loads all variables used within the script.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Determine where the R script is located
  str_location_master <-paste("//edin-nhq-nas2/DeptData/PPU/",
                              "MIDept/3_All Staff Folders/Clinical Outcomes Analysis Team/",
                              "02 Projects/04 R Projects/",
                              "fantasy_premier_league",
                              sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# load all packages
  source(paste(str_location_master,
               "scripts",
               "packages.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load all variables
  source(paste(str_location_master,
               "scripts",
               "variables.R",
               sep = "/"))
  
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
  
# Clear Variables ==============================================================
# This section clears all variables that are no longer required.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear Data Frames
  rm(df_fpl_player_data)
  
# Create Data Frame ============================================================
# This section creates a data frames of all available data.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Teams Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_teams.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Players Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_players.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Player Types Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_player_types.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear completed data frames
  rm(df_fpl_teams_data,
     df_fpl_players_data,
     df_fpl_player_types_data)
  
# Extract Data =================================================================
# This section extracts each .csv file and combines them into one data frame
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
# Disconnect from database
  dbDisconnect(db_connection_cod)
  
  rm(db_connection_cod)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear completed data frames
  rm(df_fpl_teams_data,
     df_fpl_players_data,
     df_fpl_player_types_data)
  
# Clear Variables ==============================================================
# This section clears all variables used within the script.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Data frames
  rm(df_manager_ids)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Database connection
  rm(str_cod_server,
     str_cod_database,
     str_cod_db_userid,
     str_cod_db_password)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Variables
  rm(lst_fpl_managers,
     lst_season_list,
     lst_fpl_player_data,
     int_player_selection_gameweek,
     int_current_gameweek,
     int_gameweek_range,
     str_active_season,
     str_location_master,
     str_league_id,
     str_season_name,
     str_active_fpl_player,
     str_active_upload_season,
     str_active_season_folder)
  
# Procedure End ================================================================
  dat_end_time <- Sys.time()
  int_run_time <- as.numeric(round(difftime(dat_end_time,dat_start_time,
                                            units="mins"), 
                                   digits = 0))
  print(paste("Process Completed:",int_run_time, "minute(s) run time"))
  
  rm(dat_end_time,
     dat_start_time,
     int_run_time)