# Script name:  output_player_selection.R
# Written by:   Andrew Kent
# Purpose:      This script creates an extract file to be used for weekly player
#               selection

# Import Data ==================================================================
# Connect to database and return the data into a data frame
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Connect to database
  db_connection_cod <- DBI::dbConnect(odbc::odbc(),
                                      Driver = "{SQL Server}",
                                      Server = str_cod_server,
                                      Database = str_cod_database,
                                      UID = str_cod_db_userid,
                                      PWD = str_cod_db_password)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create SQL query
  sql_query <- paste("-- RStudio Process -- Andrew Kent
                      SELECT
                        fpl_players_data.id AS player_id,
                      	fpl_players_data.web_name AS player_name,
                      	fpl_player_types_data.id AS position_id,
                      	fpl_player_types_data.singular_name_short AS position,
                      	fpl_teams_data.id AS team_id,
                      	fpl_teams_data.name AS team,
                      	fpl_ownership_data.id AS current_owner_id,
                      	fpl_managers_data.player_first_name AS current_owner,
                      	fpl_players_data.now_cost AS cost,
                      	fpl_players_data.status AS status,
                      	fpl_players_data.chance_of_playing_this_round,
                      	fpl_players_data.chance_of_playing_next_round,
                      	fpl_players_data.total_points AS total_points,
                      	fpl_players_data.starts AS total_starts,
                      	fpl_players_data.minutes AS total_minutes,
                      	fpl_players_data.goals_scored AS total_goals_scored,
                      	fpl_players_data.expected_goals AS total_expected_goals,
                      	fpl_players_data.assists AS total_assists,
                      	fpl_players_data.expected_assists AS total_expected_assists,
                      	fpl_players_data.goals_conceded AS total_goals_conceded,
                      	fpl_players_data.expected_goals_conceded AS total_expected_goals_conceded,
                      	fpl_players_data.bps AS total_bps,
                      	fpl_players_data.ict_index AS total_ict_index
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
                      	LEFT OUTER JOIN
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_players_data] AS fpl_players_data
                      		ON (
                      			fpl_gameweeks_data.player_id = fpl_players_data.id
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_players_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_player_types_data] AS fpl_player_types_data
                      		ON (
                      			fpl_players_data.element_type = fpl_player_types_data.id
                      			AND
                      			fpl_players_data.season_name = fpl_player_types_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_teams_data] AS fpl_teams_data
                      		ON (
                      			fpl_players_data.team = fpl_teams_data.id
                      			AND
                      			fpl_players_data.season_name = fpl_teams_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_ownership_data] AS fpl_ownership_data
                      		ON (
                      			fpl_gameweeks_data.player_id = fpl_ownership_data.element
                      			AND
                      			fpl_gameweeks_data.gameweek = fpl_ownership_data.gameweek
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_managers_data] AS fpl_managers_data
                      		ON (
                      			fpl_ownership_data.id = fpl_managers_data.id
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
                      			)
                      WHERE
                      	fpl_players_data.season_name = '", str_season_name ,"'
                      	AND
                      	fpl_gameweeks_data.gameweek = ", int_player_selection_gameweek ,"
                      	AND
                      	(
                        fpl_managers_data.name <> 'Spartak Kent'
                        AND
                        fpl_managers_data.name <> 'Paint it Maroon'
                        OR
                        fpl_managers_data.name IS NULL
                        )
                      ORDER BY
                      	fpl_teams_data.short_name,
                      	fpl_players_data.element_type,
                      	fpl_players_data.web_name,
                      	fpl_gameweeks_data.gameweek ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_player_selection <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create SQL query
  sql_query <- paste("-- RStudio Process -- Andrew Kent
                      SELECT
                        fpl_manager_chips_data.id AS current_owner_id,
                      	fpl_managers_data.player_first_name AS current_owner,
                      	fpl_managers_data.name AS current_owner_team,
                      	fpl_manager_chips_data.event AS gameweek,
                      	fpl_manager_chips_data.name AS chip_played
                      FROM 
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_manager_chips_data] AS fpl_manager_chips_data
                      		LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_managers_data] AS fpl_managers_data
                      		ON (
                      			fpl_manager_chips_data.id = fpl_managers_data.id
                      			AND
                      			fpl_manager_chips_data.season_name = fpl_managers_data.season_name
                      			)
                      WHERE
                      	fpl_manager_chips_data.name = 'freehit'
                      	AND
                      	fpl_manager_chips_data.season_name = '", str_season_name ,"'
                      	AND
                      	fpl_manager_chips_data.event = ", int_player_selection_gameweek ,"
                      	AND
                      	(
                        fpl_managers_data.name <> 'Spartak Kent'
                        AND
                        fpl_managers_data.name <> 'Paint it Maroon'
                        )
                      ORDER BY
                        fpl_manager_chips_data.event,
                        fpl_managers_data.player_first_name ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_free_hit_marker <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create SQL query
  sql_query <- paste("-- RStudio Process -- Andrew Kent
                      SELECT
                        fpl_players_data.id AS player_id,
                      	fpl_players_data.web_name AS player_name,
                      	fpl_player_types_data.id AS position_id,
                      	fpl_player_types_data.singular_name_short AS position,
                      	fpl_teams_data.id AS team_id,
                      	fpl_teams_data.name AS team,
                      	fpl_ownership_data.id AS current_owner_id,
                      	fpl_managers_data.player_first_name AS current_owner,
                      	fpl_players_data.now_cost AS cost,
                      	fpl_players_data.status AS status,
                      	fpl_players_data.chance_of_playing_this_round,
                      	fpl_players_data.chance_of_playing_next_round,
                      	fpl_players_data.total_points AS total_points,
                      	fpl_players_data.starts AS total_starts,
                      	fpl_players_data.minutes AS total_minutes,
                      	fpl_players_data.goals_scored AS total_goals_scored,
                      	fpl_players_data.expected_goals AS total_expected_goals,
                      	fpl_players_data.assists AS total_assists,
                      	fpl_players_data.expected_assists AS total_expected_assists,
                      	fpl_players_data.goals_conceded AS total_goals_conceded,
                      	fpl_players_data.expected_goals_conceded AS total_expected_goals_conceded,
                      	fpl_players_data.bps AS total_bps,
                      	fpl_players_data.ict_index AS total_ict_index
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
                      	LEFT OUTER JOIN
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_players_data] AS fpl_players_data
                      		ON (
                      			fpl_gameweeks_data.player_id = fpl_players_data.id
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_players_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_player_types_data] AS fpl_player_types_data
                      		ON (
                      			fpl_players_data.element_type = fpl_player_types_data.id
                      			AND
                      			fpl_players_data.season_name = fpl_player_types_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_teams_data] AS fpl_teams_data
                      		ON (
                      			fpl_players_data.team = fpl_teams_data.id
                      			AND
                      			fpl_players_data.season_name = fpl_teams_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_ownership_data] AS fpl_ownership_data
                      		ON (
                      			fpl_gameweeks_data.player_id = fpl_ownership_data.element
                      			AND
                      			fpl_gameweeks_data.gameweek = fpl_ownership_data.gameweek
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
                      			)
                      	LEFT OUTER JOIN
                      		[Clinical_Outcomes_Analysis].[dbo].[fpl_managers_data] AS fpl_managers_data
                      		ON (
                      			fpl_ownership_data.id = fpl_managers_data.id
                      			AND
                      			fpl_gameweeks_data.season_name = fpl_ownership_data.season_name
                      			)
                      WHERE
                      	fpl_players_data.season_name = '", str_season_name ,"'
                      	AND
                      	fpl_gameweeks_data.gameweek = ", int_player_selection_gameweek - 1 ,"
                      	AND
                      	(
                        fpl_managers_data.name <> 'Spartak Kent'
                        AND
                        fpl_managers_data.name <> 'Paint it Maroon'
                        OR
                        fpl_managers_data.name IS NULL
                        )
                      ORDER BY
                      	fpl_teams_data.short_name,
                      	fpl_players_data.element_type,
                      	fpl_players_data.web_name,
                      	fpl_gameweeks_data.gameweek ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_player_selection_previous_week <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Disconnect from database and remove variables
  dbDisconnect(db_connection_cod)
  
  rm(db_connection_cod)
  
# Free Hit Modelling ===========================================================
# This section models the data and takes into consideration when a free hit has 
# been played
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Was a free hit played
  str_free_hits_active <- ifelse(nrow(df_free_hit_marker) == 0,
                                 "No",
                                 "Yes")
  
  ifelse(str_free_hits_active == "Yes",
         df_free_hit_marker <- df_free_hit_marker[c("current_owner_id",
                                                    "chip_played")], NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge df_free_hit_marker data frame with df_player_selection and
# df_player_selection_previous_week data frames
  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- merge(df_player_selection, 
                                      df_free_hit_marker, 
                                      by.x = c("current_owner_id"),
                                      by.y = c("current_owner_id"), 
                                      all.x = TRUE), NA)
  
  ifelse(str_free_hits_active == "Yes",
         df_player_selection_previous_week <- merge(df_player_selection_previous_week, 
                                                    df_free_hit_marker, 
                                                    by.x = c("current_owner_id"),
                                                    by.y = c("current_owner_id"), 
                                                    all.x = TRUE), NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Keep only relevant data
  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- subset(df_player_selection,
                                       is.na(df_player_selection$chip_played) == TRUE), NA)
  
  ifelse(str_free_hits_active == "Yes",
         df_player_selection_previous_week <- subset(df_player_selection_previous_week,
                                                     is.na(df_player_selection_previous_week$chip_played) == FALSE), NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Combine data frames
  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- rbind(df_player_selection,
                                      df_player_selection_previous_week), NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# fill in missing data
  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- df_player_selection %>%
                                dplyr::group_by(player_id) %>%
                                tidyr::fill(current_owner_id, .direction = "downup") %>%
                                dplyr::ungroup(), NA)

  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- df_player_selection %>%
                                dplyr::group_by(player_id) %>%
                                tidyr::fill(current_owner, .direction = "downup") %>%
                                dplyr::ungroup(), NA)

  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- df_player_selection %>%
                                dplyr::group_by(player_id) %>%
                                tidyr::fill(chip_played, .direction = "downup") %>%
                                dplyr::ungroup(), NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove duplicates
  ifelse(str_free_hits_active == "Yes",
         df_player_selection <- distinct(df_player_selection,
                                         player_id, .keep_all = TRUE), NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# free hit flag
  ifelse(str_free_hits_active == "Yes",
         df_player_selection$free_hit_flag <- ifelse(is.na(df_player_selection$chip_played) == TRUE,
                                                     "-",
                                                     "free hit was played"),
         df_player_selection$free_hit_flag <- "-")
  
  ifelse(str_free_hits_active == "Yes",
         df_player_selection$chip_played <- NULL, NA)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data frames
  rm(df_free_hit_marker,
     df_player_selection_previous_week)
  
# Merge Team Data ==============================================================
# This section merges team data on previous result and upcoming fixtures
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Previous results
  df_previous_results$team_name <- NULL
  df_previous_results$season_name <- NULL
  
  df_player_selection <- merge(df_player_selection, 
                               df_previous_results, 
                               by.x = c("team_id"),
                               by.y = c("team_id"), 
                               all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Upcoming fixtures
  df_upcoming_fixtures$team_name <- NULL
  df_upcoming_fixtures$season_name <- NULL
  
  df_player_selection <- merge(df_player_selection, 
                               df_upcoming_fixtures, 
                               by.x = c("team_id"),
                               by.y = c("team_id"), 
                               all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data
  rm(df_previous_results,
     df_upcoming_fixtures)
  
# Merge Player Form ============================================================
# This section includes the player form data with the player selection data
# frame
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Player form
  df_player_selection_form$season_name <- NULL
  
  df_player_selection <- merge(df_player_selection, 
                               df_player_selection_form, 
                               by.x = c("player_id"),
                               by.y = c("player_id"), 
                               all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data
  rm(df_player_selection_form)
      
# Tidy Variables ===============================================================
# This section tidies each variable ready for use
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# current owner
  df_player_selection$current_owner <- ifelse(is.na(df_player_selection$current_owner) == TRUE,
                                              "Free Agent",
                                              df_player_selection$current_owner)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# cost
  df_player_selection$cost <- df_player_selection$cost / 10
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# status
  df_selection_matrix <- data.frame(status = c("a","d","i","s","n","u"),
                                    status_description = c("available","doubtful","injured","suspended","unavailable","unavailable"))
  
  df_player_selection <- merge(df_player_selection, 
                               df_selection_matrix, 
                               by.x = c("status"),
                               by.y = c("status"), 
                               all.x = TRUE)
  
  df_player_selection$status <- df_player_selection$status_description
  
  df_player_selection$status_description <- NULL
  
  rm(df_selection_matrix)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# chance of playing
  df_player_selection$chance_of_playing_this_round <- ifelse(is.na(df_player_selection$chance_of_playing_this_round) == TRUE,
                                                             100,df_player_selection$chance_of_playing_this_round)

  df_player_selection$chance_of_playing_next_round <- ifelse(is.na(df_player_selection$chance_of_playing_next_round) == TRUE,
                                                             100,df_player_selection$chance_of_playing_next_round)
  
  df_player_selection$chance_of_playing_this_round <- df_player_selection$chance_of_playing_this_round / 100
  
  df_player_selection$chance_of_playing_next_round <- df_player_selection$chance_of_playing_next_round / 100
  
# Sort Data ====================================================================
# This section sorts the data into the required order
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  df_player_selection <- df_player_selection[order(df_player_selection$team_id,
                                                   df_player_selection$position_id,
                                                   df_player_selection$player_name) , ]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  df_player_selection$team_id <- NULL
  df_player_selection$position_id <- NULL
  df_player_selection$current_owner_id <- NULL
  df_player_selection$current_owner_team <- NULL
  
# Organize Data ================================================================
# This section organizes the variables into the desired order
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  df_player_selection <- df_player_selection[c("player_id",
                                               "player_name",
                                               "position",
                                               "team",
                                               "current_owner",
                                               "free_hit_flag",
                                               "cost",
                                               "status",
                                               "chance_of_playing_this_round",
                                               "chance_of_playing_next_round",
                                               "form_starts",
                                               "form_minutes",
                                               "form_total_points",
                                               "form_goals_scored",
                                               "form_assists",
                                               "form_goals_conceded",
                                               "form_bps",
                                               "form_influence",
                                               "form_creativity",
                                               "form_threat",
                                               "form_ict_index",
                                               "form_expected_goals",
                                               "form_expected_assists",
                                               "form_expected_goal_involvements",
                                               "form_expected_goals_conceded",
                                               "results_team_played",
                                               "results_team_goals_scored",
                                               "results_team_goals_conceded",
                                               "results_team_points",
                                               "results_team_strength",
                                               "results_team_attack",
                                               "results_team_defense",
                                               "results_opposition_strength",
                                               "results_opposition_attack",
                                               "results_opposition_defense",
                                               "fixtures_team_fixtures",
                                               "fixtures_team_strength",
                                               "fixtures_team_attack",
                                               "fixtures_team_defense",
                                               "fixtures_opposition_strength",
                                               "fixtures_opposition_attack",
                                               "fixtures_opposition_defense",
                                               "total_starts",
                                               "total_minutes",
                                               "total_points",
                                               "total_goals_scored",
                                               "total_expected_goals",
                                               "total_assists",
                                               "total_expected_assists",
                                               "total_goals_conceded",
                                               "total_expected_goals_conceded",
                                               "total_bps",
                                               "total_ict_index")]
  
# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  write.table(df_player_selection,
              file = paste(str_location_master,
                           "/outputs/",
                           "fpl_player_selection.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")
  
# Clear Variables ==============================================================
# This section clears the variables that are no longer required
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear variables
  rm(str_season_name,
     int_player_selection_gameweek,
     df_player_selection)