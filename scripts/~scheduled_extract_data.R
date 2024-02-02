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
               description = "data extract routine run")
  
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