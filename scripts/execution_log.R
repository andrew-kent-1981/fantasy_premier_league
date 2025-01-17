# Script name:  execution_log.R
# Written by:   Andrew Kent
# Purpose:      Controls the logging of scheduled script runs, including 
#               recording start times, run durations, and tracking execution 
#               progress in a log file.

# Execution Log ================================================================
# This section updates a log file that tacks when each scheduled run rook place
# and how long it took to run.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Import previous data.
  tbl_previous_data <-
    read_excel(file.path(str_location_master,
                         "execution_log",
                         "execution_log.xlsx"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Count Rows.
  int_count <- nrow(tbl_previous_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Calculate runtime.
  dat_end_time <- Sys.time()
  
  int_run_time <- 
    as.numeric(round(difftime(dat_end_time,
                              dat_start_time,
                              units="mins"), 
                     digits = 0))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create new entry.
  tbl_temp_data <- 
    tibble(time = ymd_hms(dat_start_time),
           runtime = as.numeric(int_run_time),
           count = int_count + 1,
           description = "data model updated")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Combine data.
  tbl_latest_data <-
    bind_rows(tbl_previous_data, 
              tbl_temp_data)
  
  rm(tbl_previous_data, 
     tbl_temp_data)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Export data.
  write_xlsx(tbl_latest_data, 
             path = file.path(str_location_master,
                              "execution_log",
                              "execution_log.xlsx"), 
             col_names  = TRUE, 
             format_headers = FALSE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear variables.
  rm(tbl_latest_data)
