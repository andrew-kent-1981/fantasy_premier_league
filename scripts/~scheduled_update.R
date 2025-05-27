# Script name:  ~scheduled_update.R
# Written by:   Andrew Kent
# Purpose:      This script is used to extract data from the Fantasy Premier 
#               League. It runs as a scheduled task.

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

# Download & Backup Data =======================================================
# This section downloads and backs up all available Fantasy Premier League data
# for the current season, ready for use.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  source(file.path(str_location_master,
                   "scripts",
                   "scrape_data.R"))
  
# Create Data Frame ============================================================
# This section creates a data frames of all available data.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_managers.R"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Manager Current Season Data
  source(file.path(str_location_master,
                   "scripts",
                   "dataframe_manager_current_season.R"))
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
  
# Email Confirmation ===========================================================
# This section sends a confirmation email to indicate that the process has been
# run successfully.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Send email confirmation.
  source(file.path(str_location_master,
                   "scripts",
                   "email_confirmation.R"))
  
# Obsidian Integration =========================================================
# This section backs up all scripts within the project to Obsidian so that they
# Can be integrated into note taking.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Backup scripts to Obsidian.
  source(file.path(str_location_master,
                   "scripts",
                   "obsidian_integration.R"))
  
# Execution Log ================================================================
# This section updates a log file that tacks when each scheduled run rook place
# and how long it took to run.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Update schedule log.
  source(file.path(str_location_master,
                   "scripts",
                   "execution_log.R"))
  
# Procedure End ================================================================
# This section provides confirmation that the process has run successfully and 
# displays how long it has taken.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  print(paste("Process Completed:",
              int_run_time, 
              "minute(s) run time"))
  
# Clear Variables ==============================================================
# This section clears all variables used within the script.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear end of procedure variables.
  rm(str_location_master,
     int_run_time,
     int_count,
     dat_start_time,
     dat_end_time)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Data frames
  rm(df_manager_ids)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Database connection
  rm(str_bi_cod_server,
     str_bi_cod_database)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Variables
  rm(str_active_upload_season,
     lst_fpl_managers,
     lst_season_list,
     int_current_gameweek,
     int_gameweek_range,
     int_player_selection_gameweek,
     str_active_season,
     str_league_id,
     str_active_season_folder,
     str_season_name)
