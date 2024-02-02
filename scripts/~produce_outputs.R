# Script name:  ~master_extract_data.R
# Written by:   Andrew Kent
# Purpose:      This script is used to produce output data from the Fantasy
#               Premier League data that has been updated.

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