# ------------------------------------------------------------------------------
# Script Name:    ~weekly_extracts.R
# Author:         Andrew Kent
# Date Created:   2025-08-22
# Purpose:        This R script automates the extraction, transformation, and 
#                 integration of Fantasy Premier League data from multiple 
#                 sources—including SQL databases, CSV files, and Excel 
#                 sheets—to produce a consolidated weekly dataset. The output 
#                 supports operational and clinical decision-making by modelling 
#                 player performance, availability, and ownership, and exporting 
#                 a clean summary for use in team selection workflows.
# ------------------------------------------------------------------------------

# PROCEDURE START --------------------------------------------------------------
# Capture script start time for timing/logging purposes.

dat_start_time <- Sys.time()

# SET WORKING DIRECTORY --------------------------------------------------------
# This section sets the working directory explicitly, as the script may be run 
# on a schedule (e.g. via Windows Task Scheduler) without access to an R
# project. Ensure this matches the server path structure used in production.

str_location_master <- 
  file.path(
    "//BUSINT-TS1/sas_business_intelligence",
    "sas_bi_clinical_outcomes/r_projects",
    "fantasy_premier_league"
  )

# LOAD PACKAGES ----------------------------------------------------------------
# These packages are required by the data model. The load order reflects when 
# each package is first used in the script to support readability and debugging.

# PACKAGE INSTALL FUNCTION -----------------------------------------------------
fun_load_package <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg, dependencies = TRUE)
    
  }
  suppressPackageStartupMessages(library(pkg, character.only = TRUE, warn.conflicts = FALSE))
}

# LOAD PACKAGES ----------------------------------------------------------------
fun_load_package("dplyr")        # Core data wrangling
fun_load_package("lubridate")    # Date-time manipulation
fun_load_package("stringr")      # String manipulation
fun_load_package("tidyverse")    # Tidyverse meta-package (includes ggplot2, tibble, tidyr, etc.)
fun_load_package("odbc")         # SQL Server connections via ODBC
fun_load_package("data.table")   # High-performance data operations
fun_load_package("readr")        # Fast reading of delimited files
fun_load_package("readxl")       # Import Excel files (.xls and .xlsx)
fun_load_package("writexl")      # Export data to Excel files (.xlsx)

# GET CURRENT GAMEWEEK ---------------------------------------------------------
# This section interrogates the Fantasy Premier League website to establish what
# the current (live) gameweek is.

# ACCESS FPL DATA --------------------------------------------------------------
lst_fpl_master_data <- jsonlite::fromJSON("https://fantasy.premierleague.com/api/bootstrap-static/")

# RETURN EVENTS TABLE ----------------------------------------------------------
df_events <- lst_fpl_master_data[["events"]]

# EXTRACT CURRENT GAMEWEEK -----------------------------------------------------
df_events <- subset(df_events,
                    df_events$is_current == TRUE)

int_current_gameweek <- ifelse(nrow(df_events) == 0,
                               1,
                               df_events$id)

# CLEAR VARIABLES --------------------------------------------------------------
rm(lst_fpl_master_data,
   df_events)

# DEFINE DATABASE VARIABLES ----------------------------------------------------
# These variables store connection details for SQL Server databases used to 
# extract and link data across multiple systems.

# CURRENT SEASON ---------------------------------------------------------------
str_current_season = "2025/26"

# EACCSQL2\BI – Clinical Outcomes Database -------------------------------------
str_bi_cod_server   <- "EACCSQL2\\BI"
str_bi_cod_database <- "sas_bi_clinical_outcomes_dev"

# FUNCTION: REPORT SCRIPT RUNTIME ----------------------------------------------
# Calculate and display the total runtime of the script given a start time.

fun_report_runtime <- function(start_time) {
  
  end_time <- Sys.time()
  duration <- difftime(end_time, start_time, units = "secs")
  
  minutes <- as.integer(duration) %/% 60
  seconds <- round(as.numeric(duration) %% 60)
  
  message(sprintf(
    "Script completed successfully in %d minute%s and %d second%s.",
    minutes,
    ifelse(minutes == 1, "", "s"),
    seconds,
    ifelse(seconds == 1, "", "s")
  ))
}

# FUNCTION: CONNECT TO DATABASE ------------------------------------------------
# This function connects to a SQL Server database using either Windows or SQL 
# authentication, runs a query, and returns the result as a tibble. Connection 
# parameters are passed as arguments.

fun_extract_data <- function(server_name   = NULL,
                             database_name = NULL,
                             userid        = NULL,
                             password      = NULL,
                             sql_query     = NULL) {
  
  # SET UP CONNECTION ARGUMENTS ------------------------------------------------
  conn_args <- list(
    Driver = "{SQL Server}",
    Server = server_name
  )
  
  if (!is.null(database_name)) {
    conn_args$Database <- database_name
  }
  
  # ADD AUTHENTICATION DETAILS -------------------------------------------------
  if (!is.null(userid) && !is.null(password)) {
    conn_args$UID <- userid
    conn_args$PWD <- password
  } else {
    conn_args$Authentication <- "Windows Authentication"
  }
  
  # ESTABLISH CONNECTION -------------------------------------------------------
  db_connection <- do.call(DBI::dbConnect, c(list(drv = odbc::odbc()), conn_args))
  
  # RUN QUERY AND FETCH RESULTS ------------------------------------------------
  sql_result  <- dbSendQuery(db_connection, sql_query)
  tibble_data <- dbFetch(sql_result)
  
  # CLEAN UP CONNECTION --------------------------------------------------------
  dbClearResult(sql_result)
  dbDisconnect(db_connection)
  
  # RETURN TIBBLE --------------------------------------------------------------
  return(tibble_data)
}

# CREATE MATRIX ----------------------------------------------------------------
# Create health_board abbreviation
tbl_matrix_status <- 
  data.frame(status = c("a", 
                        "d", 
                        "i",
                        "s", 
                        "n", 
                        "u"),
             status_updated = c("available",
                                "doubtful",
                                "injured",
                                "suspended",
                                "unavailable",
                                "unavailable"))
             
# SQL QUERY DEFINITION ---------------------------------------------------------
# Construct the SQL query to retrieve the relevant data from the source 
# database.

# CREATE QUERY -----------------------------------------------------------------
sql_query <- paste("
    -- R Data Modelling Process - Clinical Outcomes Team
    SELECT
      fpl_players_data.id                                 AS player_id,
      fpl_players_data.web_name                           AS player_name,
      fpl_player_types_data.singular_name_short           AS position,
      fpl_teams_data.name                                 AS team,
      fpl_managers_data.player_first_name                 AS current_owner,
      fpl_players_data.now_cost / 10                      AS cost,
      fpl_players_data.status                             AS status,
      fpl_players_data.chance_of_playing_this_round / 100 AS chance_of_playing_this_round,
      fpl_players_data.chance_of_playing_next_round / 100 AS chance_of_playing_next_round,
      fpl_players_data.starts                             AS starts,
      fpl_players_data.minutes                            AS minutes,
      fpl_players_data.total_points                       AS total_points,
      fpl_players_data.goals_scored                       AS goals_scored,
      fpl_players_data.assists                            AS assists,
      fpl_players_data.clean_sheets                       AS clean_sheets,
      fpl_players_data.defensive_contribution             AS defensive_contribution,
      fpl_players_data.bonus                              AS bonus_points,
      fpl_players_data.bps                                AS bonus_point_system,
      fpl_players_data.form                               AS current_form,
      fpl_players_data.ict_index                          AS ict_index,
      fpl_players_data.expected_goals                     AS expected_goals,
      fpl_players_data.expected_assists                   AS expected_assists,
      fpl_players_data.expected_goal_involvements         AS expected_goal_involvements,
      fpl_players_data.expected_goals_conceded            AS expected_goals_conceded,
      fpl_gameweeks_data.gameweek                         AS gameweek,
      fpl_players_data.season_name                        AS season
    FROM
      [", str_bi_cod_database,"].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
      LEFT OUTER JOIN
      [", str_bi_cod_database,"].[dbo].[fpl_players_data] AS fpl_players_data
          ON (
              fpl_gameweeks_data.player_id = fpl_players_data.id
              AND
              fpl_gameweeks_data.season_name = fpl_players_data.season_name
              )
      LEFT OUTER JOIN
      [", str_bi_cod_database,"].[dbo].[fpl_player_types_data] AS fpl_player_types_data
          ON (
              fpl_players_data.element_type = fpl_player_types_data.id
              AND
              fpl_players_data.season_name = fpl_player_types_data.season_name
              )
      LEFT OUTER JOIN
      [", str_bi_cod_database,"].[dbo].[fpl_teams_data] AS fpl_teams_data
          ON (
              fpl_players_data.team = fpl_teams_data.id
              AND
              fpl_players_data.season_name = fpl_teams_data.season_name
              )
      LEFT OUTER JOIN
  	(
          SELECT * 
          FROM [", str_bi_cod_database,"].[dbo].[fpl_ownership_data]
          WHERE id <> 93926
      ) AS fpl_ownership_data
          ON (
              fpl_gameweeks_data.player_id = fpl_ownership_data.element
              AND
              fpl_gameweeks_data.gameweek = fpl_ownership_data.gameweek
              AND
              fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
              )
      LEFT OUTER JOIN
      [", str_bi_cod_database,"].[dbo].[fpl_managers_data] AS fpl_managers_data
          ON (
              fpl_ownership_data.id = fpl_managers_data.id
              AND
              fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
              )
    WHERE
  	  fpl_players_data.season_name = '", str_current_season,"'
  	  AND
  	  fpl_gameweeks_data.gameweek = '", int_current_gameweek ,"'
    ORDER BY
        fpl_teams_data.short_name,
        fpl_players_data.element_type,
        fpl_players_data.web_name,
        fpl_gameweeks_data.gameweek ASC;
                   ",
                   sep = ""
)

# DATA EXTRACTION --------------------------------------------------------------
tbl_fpl_data <- fun_extract_data(
  server_name   = str_bi_cod_server,
  database_name = str_bi_cod_database,
  sql_query     = sql_query
)

# CLEANUP ----------------------------------------------------------------------
rm(sql_query)

# CSV DATA IMPORT --------------------------------------------------------------
# Import data from the specified CSV file into a data table.

# READ CSV FILE ----------------------------------------------------------------
tbl_ffs_data <- 
  read.csv(
    file.path(
      str_location_master,
      "inputs",
      "fantasy_football_scout",
      "fantasy_football_scout_rate_my_team.csv"
    )
  )

# EXCEL DATA IMPORT ------------------------------------------------------------
# Import data from the specified Excel file into a data table.

# READ EXCEL FILE - TEAM MATRIX ------------------------------------------------
tbl_matrix_team <- read_excel(
  file.path(
    str_location_master,
    "inputs",
    "fantasy_football_scout",
    "fantasy_football_scout_matrix.xlsx"
  ),
  sheet = "matrix",
  range = "B1:C100"
)

tbl_matrix_team <-
  tbl_matrix_team %>% 
  filter(!is.na(team))

# READ EXCEL FILE - POSITION MATRIX --------------------------------------------
tbl_matrix_position <- read_excel(
  file.path(
    str_location_master,
    "inputs",
    "fantasy_football_scout",
    "fantasy_football_scout_matrix.xlsx"
  ),
  sheet = "matrix",
  range = "E1:F100"
)

tbl_matrix_position <-
  tbl_matrix_position %>% 
  filter(!is.na(position))

# READ EXCEL FILE - FPL FFS MATRIX --------------------------------------------
tbl_matrix_fpl_ffs <- read_excel(
  file.path(
    str_location_master,
    "inputs",
    "fantasy_football_scout",
    "fantasy_football_scout_matrix.xlsx"
  ),
  sheet = "data_final",
  range = "A1:E10000"
)

tbl_matrix_fpl_ffs <-
  tbl_matrix_fpl_ffs %>% 
  filter(!is.na(fpl_id))


# MODEL DATA -------------------------------------------------------------------
# This section combines and models data from each source and generates a file
# ready to be used in final weekly team selections.

# MODEL FFS DATA ---------------------------------------------------------------
tbl_ffs_data <-
  tbl_ffs_data %>% 
  rename_with(.fn = ~ gsub("^GW(\\d+)$", "ffs_gw_\\1", .x),
              .cols = everything()) %>% 
  rename(ffs_player = "Player",
         ffs_position = "Pos",
         ffs_team = "Team",
         ffs_total = "Total") %>% 
  select(-Price,
         -Value)

tbl_ffs_data <-
  left_join(tbl_ffs_data,
            tbl_matrix_team,
            by = c("ffs_team" = "team"))

tbl_ffs_data <-
  left_join(tbl_ffs_data,
            tbl_matrix_position,
            by = c("ffs_position" = "position"))

tbl_ffs_data <-
  tbl_ffs_data %>% 
  select(-ffs_team,
         -ffs_position) %>% 
  rename(ffs_team = "team_short",
         ffs_position = "position_short")

tbl_ffs_data <-
  left_join(tbl_ffs_data,
            tbl_matrix_fpl_ffs %>% 
              select(-fpl_player),
            by = c("ffs_player" = "ffs_player",
                   "ffs_team" = "fpl_team",
                   "ffs_position" = "fpl_position"))

# MODEL MASTER DATA ------------------------------------------------------------
# This section models the master data frame that will be used to make weekly
# team changes.

# CREATE MASTER DATA FRAME -----------------------------------------------------
tbl_master_weekly_extract <-
  left_join(tbl_fpl_data,
            tbl_ffs_data %>% 
              select(-ffs_player,
                     -ffs_team,
                     -ffs_position),
            by = c("player_id" = "fpl_id"))

# MODEL STATUS -----------------------------------------------------------------
tbl_master_weekly_extract <-
  left_join(tbl_master_weekly_extract,
            tbl_matrix_status, 
            by = "status") %>%
  mutate(status = status_updated) %>%
  select(-status_updated)

# MODEL OTHER VARIABLES --------------------------------------------------------
tbl_master_weekly_extract <-
  tbl_master_weekly_extract %>% 
  mutate(current_owner = case_when(is.na(current_owner) ~ "Free Agent",
                                   TRUE ~ current_owner),
         chance_of_playing_this_round = case_when(status == "available" & is.na(chance_of_playing_this_round) ~ 1,
                                                  is.na(chance_of_playing_this_round) ~ 0,
                                                  TRUE ~ chance_of_playing_this_round),
         chance_of_playing_next_round = case_when(status == "available" & is.na(chance_of_playing_next_round) ~ 1,
                                                  is.na(chance_of_playing_next_round) ~ 0,
                                                  TRUE ~ chance_of_playing_next_round))

# FINALISE DATA TABLE ----------------------------------------------------------
tbl_master_weekly_extract <-
  tbl_master_weekly_extract %>% 
  arrange(-total_points) %>% 
  distinct()

# CLEAR VARIABLES --------------------------------------------------------------
rm(tbl_matrix_status,
   tbl_matrix_team,
   tbl_matrix_position,
   tbl_matrix_fpl_ffs,
   tbl_ffs_data,
   tbl_fpl_data)

# EXPORT DATA TABLE ------------------------------------------------------------
# Write the extracted data table to a CSV file in the outputs directory. 
# The filename includes a timestamp based on the script start time.

# WRITE XLSX -------------------------------------------------------------------
write_xlsx(
  tbl_master_weekly_extract,
  path = file.path(
    str_location_master,
    "outputs",
    paste0(
      "fpl_master_extract_",
      format(dat_start_time, "%Y%m%d"),
      ".xlsx")))

# CREATE LEAGUE RESULTS EXTRACT ------------------------------------------------
# This section creates a league results extract which will be used by Copilot
# to write humours match reports.

# WEEKLY MATCH REPORT -----------------------------------------------------------------
sql_query <- paste("
    -- R Data Modelling Process - Clinical Outcomes Team
    SELECT
    	fpl_ownership_data.gameweek										                  AS gameweek,
    	fpl_managers_data.player_first_name								              AS manager_name,
    	fpl_managers_data.name										                    	AS manager_team,
    	fpl_players_data.web_name									    	                AS player_name,
    	fpl_ownership_data.position										                  AS starting_position,
    	fpl_player_types_data.singular_name_short						            AS position,
    	fpl_teams_data.short_name										                    AS player_team,
    	CASE
    		WHEN fpl_ownership_data.multiplier > 1
    		THEN 'Captain'
    		ELSE NULL
    	END																                              AS captain,
    	fpl_gameweeks_data.minutes										                  AS minutes,
    	fpl_gameweeks_data.goals_scored									                AS goals_scored,
    	fpl_gameweeks_data.assists										                  AS assists,
    	fpl_gameweeks_data.clean_sheets									                AS clean_sheets,
    	fpl_gameweeks_data.goals_conceded								                AS goals_conceded,
    	fpl_gameweeks_data.own_goals									                  AS own_goals,
    	fpl_gameweeks_data.penalties_saved							      	        AS penalties_saved,
    	fpl_gameweeks_data.penalties_missed								              AS penalties_missed,
    	fpl_gameweeks_data.yellow_cards									                AS yellow_cards,
    	fpl_gameweeks_data.red_cards									                  AS red_cards,
    	fpl_gameweeks_data.saves										                    AS saves,
    	fpl_gameweeks_data.bonus										                    AS bonus,
    	fpl_gameweeks_data.defensive_contribution						            AS defensive_contribution,
      CASE
        WHEN fpl_ownership_data.multiplier = 0
        THEN 'Benched'
        ELSE 'Played'
      END                                                             AS match_status,
    	fpl_gameweeks_data.total_points                                 AS total_points
    FROM 
    	[", str_bi_cod_database,"].[dbo].[fpl_ownership_data]
    	LEFT JOIN [", str_bi_cod_database,"].[dbo].[fpl_players_data] AS fpl_players_data
    		ON 
    		  (
          fpl_ownership_data.element = fpl_players_data.id
          AND
          fpl_ownership_data.season_name = fpl_players_data.season_name
          )
    	LEFT JOIN [", str_bi_cod_database,"].[dbo].[fpl_player_types_data] AS fpl_player_types_data
    		ON 
    		  (
    			fpl_ownership_data.element_type = fpl_player_types_data.id
          AND
          fpl_ownership_data.season_name = fpl_player_types_data.season_name
          )
    	LEFT JOIN [", str_bi_cod_database,"].[dbo].[fpl_managers_data] AS fpl_managers_data
    		ON 
    		  (
    			fpl_ownership_data.id = fpl_managers_data.id
          AND
          fpl_ownership_data.season_name = fpl_managers_data.season_name
          )
    	LEFT JOIN [", str_bi_cod_database,"].[dbo].[fpl_teams_data] AS fpl_teams_data
    		ON (
    			fpl_players_data.team = fpl_teams_data.id
                AND
                fpl_players_data.season_name = fpl_teams_data.season_name
                )
    	LEFT JOIN [", str_bi_cod_database,"].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
    		ON 
    		    (
            fpl_ownership_data.element = fpl_gameweeks_data.player_id
            AND
    			  fpl_ownership_data.gameweek = fpl_gameweeks_data.gameweek
    			  AND
            fpl_ownership_data.season_name = fpl_gameweeks_data.season_name
            )
    WHERE
      fpl_ownership_data.gameweek = ", int_current_gameweek, "
      AND
	    fpl_players_data.season_name = '", str_current_season,"'
    ORDER BY
    	fpl_managers_data.name,
    	fpl_ownership_data.position ASC
                   ",
                   sep = ""
)

# DATA EXTRACTION --------------------------------------------------------------
tbl_weekly_match_report <- fun_extract_data(
  server_name   = str_bi_cod_server,
  database_name = str_bi_cod_database,
  sql_query     = sql_query
)

# CLEANUP ----------------------------------------------------------------------
rm(sql_query)

# WRITE XLSX -------------------------------------------------------------------
write_xlsx(
  tbl_weekly_match_report,
  path = file.path(
    str_location_master,
    "outputs",
    paste0(
      "fpl_weekly_match_report_",
      format(dat_start_time, "%Y%m%d"),
      ".xlsx")))

# CLEAR DATA -------------------------------------------------------------------
# This section clears all datasets, functions, and variables from the 
# environment once they are no longer needed, to free up memory and avoid
# conflicts.

# REMOVE DATASETS --------------------------------------------------------------
rm(tbl_master_weekly_extract,
   tbl_weekly_match_report)

# REMOVE FUNCTIONS -------------------------------------------------------------
rm(
  fun_load_package,
  fun_extract_data
)

# REMOVE VARIABLES -------------------------------------------------------------
rm(
  str_current_season,
  int_current_gameweek,
  str_bi_cod_server,
  str_bi_cod_database,
  str_location_master
)

# RUN GARBAGE COLLECTION TO FREE MEMORY IMMEDIATELY ----------------------------
gc()

# PROCEDURE END ----------------------------------------------------------------
# Report total script runtime.

fun_report_runtime(dat_start_time)
rm(dat_start_time,
   fun_report_runtime)
