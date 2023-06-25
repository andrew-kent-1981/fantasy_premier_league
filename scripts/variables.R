# Script name:  variables.R
# Written by:   Andrew Kent
# Purpose:      Central script for determining all variables that are used
#               within the project.

# Set Variables ================================================================
# This section sets all variables that are used within the data model
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Active Season
  str_active_season <- "Season 22-23"
  
  str_active_season_folder <- paste(tolower(str_sub(str_active_season, start = 1,  end = 6)),
                                    str_sub(str_active_season, start = 8,  end = 9),
                                    str_sub(str_active_season, start = 11,  end = 12),
                                    sep = "_")
  
  str_season_name <- paste("20",
                           str_sub(str_active_season, start = 8,  end = 9),
                           "/",
                           str_sub(str_active_season, start = 11,  end = 12),
                           sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load Variables for connecting to the Clinical Outcomes DataMart
  str_cod_server <- "WEST-EMDC-MI4"
  str_cod_database <- "Clinical_Outcomes_Analysis"
  str_cod_db_userid <- "E9886503"
  str_cod_db_password <- "password"

# FPL Managers & League IDs ====================================================
# This section determines the IDs of each manager and the league they play in.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load manager ids
  df_manager_ids <- read_excel(paste(str_location_master,
                                     "inputs",
                                     "manager_ids.xlsx", 
                                     sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Select the current season
  df_manager_ids <- subset(df_manager_ids,
                           df_manager_ids$season == str_active_season)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare for conversion
  df_manager_ids$id <- as.character(df_manager_ids$id)
  
  df_manager_ids <- mutate(df_manager_ids, row = row_number())
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Convert to list
  lst_fpl_managers <- split(df_manager_ids$id, df_manager_ids$row)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# load league id
  str_league_id <- as.character(distinct(df_manager_ids[c("league_id")],
                                         league_id, .keep_all = TRUE))
  
  str_league_id <- unlist(str_league_id)
  
# Season List ==================================================================
# This section determines what seasons data exists for
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load data
  df_season_list <- read_excel(paste(str_location_master,
                                     "inputs",
                                     "manager_ids.xlsx", 
                                     sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# create season list
  df_season_list <- df_season_list[c("season")]
  
  df_season_list <- distinct(df_season_list,
                             season, .keep_all = TRUE)
  
  df_season_list$season_folder <- paste(tolower(str_sub(df_season_list$season, start = 1,  end = 6)),
                                        str_sub(df_season_list$season, start = 8,  end = 9),
                                        str_sub(df_season_list$season, start = 11,  end = 12),
                                        sep = "_")
  
  df_season_list$season <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare for conversion
  df_season_list <- mutate(df_season_list, row = row_number())
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Convert to list
  lst_season_list <- split(df_season_list$season_folder,
                           df_season_list$row)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data frame
  rm(df_season_list)
  
# Get Current Gameweek =========================================================
# This section interrogates the Fantasy Premier League website to establish what
# the current (live) gameweek is.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Access FPL Data
  lst_fpl_master_data <- jsonlite::fromJSON("https://fantasy.premierleague.com/api/bootstrap-static/")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return the Events table
  df_events <- lst_fpl_master_data[["events"]]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Extract the current Gameweek
  df_events <- subset(df_events,
                      df_events$is_current == TRUE)
  
  int_current_gameweek <- ifelse(nrow(df_events) == 0,
                                 1,
                                 df_events$id)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Set player selection gameweek
  int_player_selection_gameweek <- int_current_gameweek
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data that is no longer required
  rm(lst_fpl_master_data,
     df_events)
  
# Set Game Variables ===========================================================
# This section sets the range of gameweeks that the player selection scripts 
# will use
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  int_gameweek_range <- 3