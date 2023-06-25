# Script name:  ~master_extract_data.R
# Written by:   Andrew Kent
# Purpose:      This script is used to extract data from the Fantasy Premier 
#               League API, back it up, and write it to the database.

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
  
# Download & Backup Data =======================================================
# This section downloads and backs up all available Fantasy Premier League data
# for the current season, ready for use.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  source(paste(str_location_master,
               "scripts",
               "scrape_data.R",
               sep = "/"))
  
# Create Data Frame ============================================================
# This section creates a data frames of all available data.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_managers.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Current Season Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_manager_current_season.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Transfers Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_manager_transfers.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Chips Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_manager_chips.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager History Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_manager_history.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Fixtures Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_fixtures.R",
               sep = "/"))
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
# Player History Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_player_history.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Gameweeks Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_gameweeks.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Ownership Data
  source(paste(str_location_master,
               "scripts",
               "dataframe_ownership.R",
               sep = "/"))
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
  source(paste(str_location_master,
               "scripts",
               "upload_data.R",
               sep = "/"))
  
# Create Player Selection Output ===============================================
# This section creates the data frames that will be used within the construction
# of the player selection output
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Results ans fixtures data frame
  source(paste(str_location_master,
               "scripts",
               "output_results_and_fixtures.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Player form data frame
  source(paste(str_location_master,
               "scripts",
               "output_player_form.R",
               sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create master player selection
  source(paste(str_location_master,
               "scripts",
               "output_player_selection.R",
               sep = "/"))
  
# Create Outputs ===============================================================
# This section creates output files from the collated data to be used in 
# player selection and analysis
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Draft extract
  
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Results analysis
  source(paste(str_location_master,
               "scripts",
               "output_results_analysis.R",
               sep = "/"))
  
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
     str_active_season,
     str_location_master,
     str_league_id,
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