# Script name:  output_player_form.R
# Written by:   Andrew Kent
# Purpose:      This script is used to create the data frames that will support
#               the player selection output. This script focuses on creating
#               player form data.

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
                      	fpl_gameweeks_data.season_name AS season_name,
                      	fpl_gameweeks_data.gameweek AS gameweek,
                      	fpl_gameweeks_data.player_id AS player_id,
                      	fpl_gameweeks_data.total_points AS form_total_points,
                      	fpl_gameweeks_data.starts AS form_starts,
                      	fpl_gameweeks_data.minutes AS form_minutes,
                      	fpl_gameweeks_data.goals_scored AS form_goals_scored,
                      	fpl_gameweeks_data.assists AS form_assists,
                      	fpl_gameweeks_data.goals_conceded AS form_goals_conceded,
                      	fpl_gameweeks_data.bps AS form_bps,
                      	fpl_gameweeks_data.influence AS form_influence,
                      	fpl_gameweeks_data.creativity AS form_creativity,
                      	fpl_gameweeks_data.threat AS form_threat,
                      	fpl_gameweeks_data.ict_index AS form_ict_index,
                      	fpl_gameweeks_data.expected_goals AS form_expected_goals,
                      	fpl_gameweeks_data.expected_assists AS form_expected_assists,
                      	fpl_gameweeks_data.expected_goal_involvements AS form_expected_goal_involvements,
                      	fpl_gameweeks_data.expected_goals_conceded AS form_expected_goals_conceded
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
                      WHERE
                      	fpl_gameweeks_data.season_name = '2022/23'
                      ORDER BY
                      	fpl_gameweeks_data.gameweek,
                      	fpl_gameweeks_data.player_id ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_player_selection_form <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Disconnect from database and remove variables
  dbDisconnect(db_connection_cod)

  rm(db_connection_cod)
  
# Filter Data ==================================================================
# This section filters the form data so that only the last n gameweeks are 
# included
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create form data frame
  df_player_selection_form <- subset(df_player_selection_form,
                                     df_player_selection_form$gameweek > int_player_selection_gameweek - int_gameweek_range
                                   & df_player_selection_form$gameweek <= int_player_selection_gameweek)
  
# Aggregate Data ===============================================================
# This section will aggregate the data ready for use in the player selection
# script
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Aggregate data
  df_player_selection_form <- df_player_selection_form %>%
                              group_by(season_name,
                                       player_id) %>%
                              summarize(form_minutes = sum(form_minutes),
                                        form_starts = sum(form_starts),
                                        form_total_points = sum(form_total_points),
                                        form_starts = sum(form_starts),
                                        form_minutes = sum(form_minutes),
                                        form_goals_scored = sum(form_goals_scored),
                                        form_assists = sum(form_assists),
                                        form_goals_conceded = sum(form_goals_conceded),
                                        form_bps = sum(form_bps),
                                        form_influence = mean(form_influence),
                                        form_creativity = mean(form_creativity),
                                        form_threat = mean(form_threat),
                                        form_ict_index = mean(form_ict_index),
                                        form_expected_goals = mean(form_expected_goals),
                                        form_expected_assists = mean(form_expected_assists),
                                        form_expected_goal_involvements = mean(form_expected_goal_involvements),
                                        form_expected_goals_conceded = mean(form_expected_goals_conceded))