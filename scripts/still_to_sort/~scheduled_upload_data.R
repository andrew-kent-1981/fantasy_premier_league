# Script name:  ~scheduled_upload_data.R
# Written by:   Andrew Kent
# Purpose:      This script is used to upload data from the Fantasy Premier 
#               League to the database. It runs as a scheduled task.

# Procedure Start ==============================================================
  dat_start_time <- Sys.time()

# Load variables & Packages ====================================================
# This section loads all variables used within the script.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Determine where the R script is located
  str_location_master <- 
    file.path("//BUSINT-TS1/sas_business_intelligence",
              "sas_bi_clinical_outcomes/r_projects",
              "fantasy_premier_league")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# load all packages
  source(file.path(str_location_master,
                   "scripts",
                   "packages.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load all variables
  source(file.path(str_location_master,
                   "scripts",
                   "variables.R"))
  
# Create Data Frame ============================================================
# This section creates a data frames of all available data.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_managers.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Current Season Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_manager_current_season.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Transfers Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_manager_transfers.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Chips Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_manager_chips.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager History Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_manager_history.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Fixtures Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_fixtures.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Teams Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_teams.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Players Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_players.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Player Types Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_player_types.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Player History Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_player_history.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Gameweeks Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_gameweeks.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Ownership Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_ownership.R"))
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
  
# Upload Data ==================================================================
# This section combines the current season with previous seasons and uploads the 
# data to the database
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upload data
  source(file.path(str_location_master,
                   "scripts",
                   "upload_data.R"))
  
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
     int_current_gameweek,
     int_gameweek_range,
     int_player_selection_gameweek,
     str_active_season,
     str_league_id,
     str_active_season_folder,
     str_active_upload_season,
     str_season_name)
  
# Procedure End ================================================================
# This section updates a log file that tacks when each scheduled run rook place
# and how long it took to run.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Import previous data
  df_previous_data <- 
    read_excel(paste(str_location_master, 
                     "schedule",
                     "log_schedule.xlsx", 
                     sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Count Rows
  int_count <- nrow(df_previous_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Calculate runtime
  dat_end_time <- Sys.time()
  
  int_run_time <- 
    as.numeric(round(difftime(dat_end_time,dat_start_time,
                              units="mins"), 
                     digits = 0))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create new entry
  df_temp_data <-
    data.frame(time = ymd_hms(dat_start_time),
               runtime = as.numeric(int_run_time),
               count = int_count + 1,
               description = "data upload routine run")
  
  rm(int_count)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Combine Data
  df_latest_data <-
    rbind(df_previous_data, 
          df_temp_data)
  
  rm(df_previous_data, 
     df_temp_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Export Data
  write_xlsx(df_latest_data, 
             path = paste(str_location_master,
                          "schedule",
                          "log_schedule.xlsx",
                          sep = "/"), 
             col_names  = TRUE, 
             format_headers = FALSE)
  
# Procedure End ================================================================
  print(paste("Process Completed:",
              int_run_time, 
              "minute(s) run time"))
  
  rm(str_location_master,
     df_latest_data,
     dat_end_time,
     dat_start_time,
     int_run_time)