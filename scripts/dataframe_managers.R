# Script name:  dataframe_managers.R
# Written by:   Andrew Kent
# Purpose:      This script prepares and backs up data from the Fantasy Premier
#               League API, ready to be added to the database.

# FPL Manager Data =============================================================
# This section extracts data relevant to each FPL manager
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare the data frames
  df_fpl_managers_data <- NULL
  df_fpl_managers_temp <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# This section will loop through each FPL manager extracting their data in turn
  for (i in 1:length(lst_fpl_managers))
    {
      str_active_fpl_manager <- lst_fpl_managers[[i]]
      
      str_variable_link <- paste(str_location_master,
                                 "/fpl_data/",
                                 str_active_season_folder,
                                 "/manager_data/",
                                 "lst_fpl_manager_data",
                                 "_",
                                 str_active_fpl_manager,
                                 sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Create FPL entry list
      load(str_variable_link)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Remove all fields that are not required
      lst_fpl_manager_data$favourite_team <- NULL
      lst_fpl_manager_data$leagues <- NULL
      lst_fpl_manager_data$name_change_blocked <- NULL
      lst_fpl_manager_data$kit <- NULL
      lst_fpl_manager_data$entered_events <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Convert missing variables into NA
      lst_fpl_manager_data$summary_overall_points <- 
        ifelse(is.null(lst_fpl_manager_data$summary_overall_points) == TRUE,
               NA,
               lst_fpl_manager_data$summary_overall_points)
      
      lst_fpl_manager_data$summary_overall_rank <- 
        ifelse(is.null(lst_fpl_manager_data$summary_overall_rank) == TRUE,
               NA,
               lst_fpl_manager_data$summary_overall_rank)
      
      lst_fpl_manager_data$summary_event_points <- 
        ifelse(is.null(lst_fpl_manager_data$summary_event_points) == TRUE,
               NA,
               lst_fpl_manager_data$summary_event_points)
      
      lst_fpl_manager_data$summary_event_rank <- 
        ifelse(is.null(lst_fpl_manager_data$summary_event_rank) == TRUE,
               NA,
               lst_fpl_manager_data$summary_event_rank)
      
      lst_fpl_manager_data$current_event <- 
        ifelse(is.null(lst_fpl_manager_data$current_event) == TRUE,
               NA,
               lst_fpl_manager_data$current_event)
      
      lst_fpl_manager_data$last_deadline_bank <- 
        ifelse(is.null(lst_fpl_manager_data$last_deadline_bank) == TRUE,
               NA,
               lst_fpl_manager_data$last_deadline_bank)
      
      lst_fpl_manager_data$last_deadline_value <- 
        ifelse(is.null(lst_fpl_manager_data$last_deadline_value) == TRUE,
               NA,
               lst_fpl_manager_data$last_deadline_value)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Convert the remaining list data into a data frame
      df_fpl_managers_temp <- as.data.frame(matrix(unlist(lst_fpl_manager_data),
                                            nrow = length(unlist(lst_fpl_manager_data[1]))))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Rename fields
      df_fpl_managers_temp <- data.frame(setNames(df_fpl_managers_temp,
                                                 c("id",
                                                   "joined_time",
                                                   "started_event",
                                                   "player_first_name",
                                                   "player_last_name",
                                                   "player_region_id",
                                                   "player_region_name",
                                                   "player_iso_code_short",
                                                   "player_iso_code_long",
                                                   "years_active",
                                                   "summary_overall_points",
                                                   "summary_overall_rank",
                                                   "summary_event_points",
                                                   "summary_event_rank",
                                                   "current_event",
                                                   "name",
                                                   "last_deadline_bank",
                                                   "last_deadline_value",
                                                   "last_deadline_total_transfers")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#     Bind the extracted data into the master list of FPL Manager data before
#     repeating the process
      df_fpl_managers_data <- rbind(df_fpl_managers_data,
                                   df_fpl_managers_temp)
      rm(df_fpl_managers_temp)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove values that are no loner required
  rm(i,
     str_variable_link,
     str_active_fpl_manager,
     lst_fpl_manager_data)
  
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_fpl_managers_data,
              file = paste(str_location_master,
                           "/backup_data/",
                           str_active_season_folder,
                           "/",
                           "fpl_managers_data.csv", 
                           sep = ""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")