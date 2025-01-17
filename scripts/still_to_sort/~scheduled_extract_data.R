# Script name:  ~scheduled_extract_data.R
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
     dta_start_time,
     dat_end_time)
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
     str_season_name)
