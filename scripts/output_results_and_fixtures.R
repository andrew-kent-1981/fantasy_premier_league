# Script name:  output_results_and_fixtures.R
# Written by:   Andrew Kent
# Purpose:      This script is used to create the data frames that will support
#               the player selection output. This script focuses on creating
#               results and fixtures data.

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
                      	fpl_fixtures_data.season_name AS season_name,
                      	fpl_fixtures_data.event AS gameweek,
                      	fpl_fixtures_data.team_h AS team_h_id,
                      	fpl_team_h_data.short_name AS team_h_name,
                      	fpl_fixtures_data.team_h_score AS team_h_score,
                      	fpl_team_h_data.strength_overall_home AS team_h_strength_overall,
                      	fpl_team_h_data.strength_attack_home AS team_h_attack,
                      	fpl_team_h_data.strength_defence_home AS team_h_defence,
                      	fpl_fixtures_data.team_a AS team_a_id,
                      	fpl_team_a_data.short_name AS team_a_name,
                      	fpl_fixtures_data.team_a_score AS team_a_score,
                      	fpl_team_a_data.strength_overall_away AS team_a_strength_overall,
                      	fpl_team_a_data.strength_attack_away AS team_a_attack,
                      	fpl_team_a_data.strength_defence_away AS team_a_defence,
                      	CASE 
                      		WHEN fpl_fixtures_data.team_h_score > fpl_fixtures_data.team_a_score
                      		THEN 'H'
                      		WHEN fpl_fixtures_data.team_h_score < fpl_fixtures_data.team_a_score
                      		THEN 'A'
                      		WHEN fpl_fixtures_data.team_h_score = fpl_fixtures_data.team_a_score
                      		THEN 'D'
                      	END AS outcome
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_fixtures_data] AS fpl_fixtures_data
                      	LEFT OUTER JOIN [Clinical_Outcomes_Analysis].[dbo].[fpl_teams_data] AS fpl_team_h_data
                      		ON (
                      			fpl_fixtures_data.team_h = fpl_team_h_data.id
                      			AND
                      			fpl_fixtures_data.season_name = fpl_team_h_data.season_name
                      			)
                      	LEFT OUTER JOIN [Clinical_Outcomes_Analysis].[dbo].[fpl_teams_data] AS fpl_team_a_data
                      		ON (
                      			fpl_fixtures_data.team_a = fpl_team_a_data.id
                      			AND
                      			fpl_fixtures_data.season_name = fpl_team_a_data.season_name
                      			)
                      WHERE
                      	fpl_fixtures_data.season_name = '", str_season_name ,"'
                      ORDER BY
                      	fpl_fixtures_data.season_name,
                      	fpl_fixtures_data.event,
                      	fpl_team_h_data.short_name ASC",
                   sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_player_selection_fixtures <- dbFetch(sql_result)
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
# This section filters the fixture data so that only the last n gameweeks are 
# included
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create Previous Results
  df_previous_results <- subset(df_player_selection_fixtures,
                                df_player_selection_fixtures$gameweek > int_player_selection_gameweek - int_gameweek_range
                              & df_player_selection_fixtures$gameweek <= int_player_selection_gameweek)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create upcoming fixtures
  df_upcoming_fixtures <- subset(df_player_selection_fixtures,
                                 df_player_selection_fixtures$gameweek <= int_player_selection_gameweek + int_gameweek_range
                               & df_player_selection_fixtures$gameweek > int_player_selection_gameweek)

# Results Data =================================================================
# This section aggregates each data frame ready to be used
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare data frames
  df_previous_results_h <- df_previous_results[c("season_name",
                                                 "gameweek",
                                                 "team_h_id",
                                                 "team_h_name",
                                                 "team_h_score",
                                                 "team_a_score",
                                                 "outcome",
                                                 "team_h_strength_overall",
                                                 "team_h_attack",
                                                 "team_h_defence",
                                                 "team_a_strength_overall",
                                                 "team_a_attack",
                                                 "team_a_defence")]
  
  df_previous_results_a <- df_previous_results[c("season_name",
                                                 "gameweek",
                                                 "team_a_id",
                                                 "team_a_name",
                                                 "team_a_score",
                                                 "team_h_score",
                                                 "outcome",
                                                 "team_a_strength_overall",
                                                 "team_a_attack",
                                                 "team_a_defence",
                                                 "team_h_strength_overall",
                                                 "team_h_attack",
                                                 "team_h_defence")]
  
  df_previous_results_h <- data.frame(setNames(df_previous_results_h,
                                               c("season_name",
                                                 "gameweek",
                                                 "team_id",
                                                 "team_name",
                                                 "team_for",
                                                 "team_against",
                                                 "team_outcome",
                                                 "team_strength_overall",
                                                 "team_attack",
                                                 "team_defence",
                                                 "opposition_strength_overall",
                                                 "opposition_attack",
                                                 "opposition_defence")))
  
  df_previous_results_a <- data.frame(setNames(df_previous_results_a,
                                               c("season_name",
                                                 "gameweek",
                                                 "team_id",
                                                 "team_name",
                                                 "team_for",
                                                 "team_against",
                                                 "team_outcome",
                                                 "team_strength_overall",
                                                 "team_attack",
                                                 "team_defence",
                                                 "opposition_strength_overall",
                                                 "opposition_attack",
                                                 "opposition_defence")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Add points
  df_previous_results_h$points <- ifelse(df_previous_results_h$team_outcome %in% "H",
                                         3,
                                         ifelse(df_previous_results_h$team_outcome %in% "D",
                                                1, 
                                                0))
  
  df_previous_results_a$points <- ifelse(df_previous_results_a$team_outcome %in% "A",
                                         3,
                                         ifelse(df_previous_results_a$team_outcome %in% "D",
                                                1, 
                                                0))
  
  df_previous_results_h$team_outcome <-NULL
  df_previous_results_a$team_outcome <-NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Bind dataframes
  df_previous_results <- rbind(df_previous_results_h,
                               df_previous_results_a)
  
  rm(df_previous_results_h,
     df_previous_results_a)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Sort data
  df_previous_results <- df_previous_results[order(df_previous_results$season_name,
                                                   df_previous_results$gameweek,
                                                   df_previous_results$team_id) , ]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Aggregate data
  df_previous_results <- df_previous_results %>%
                         group_by(season_name,
                                  team_id,
                                  team_name) %>%
                         summarize(results_team_played = n(),
                                   results_team_goals_scored = sum(team_for) / n(),
                                   results_team_goals_conceded = sum(team_against) / n(),
                                   results_team_points = sum(points) / n(),
                                   results_team_strength = mean(team_strength_overall),
                                   results_team_attack = mean(team_attack),
                                   results_team_defense = mean(team_defence),
                                   results_opposition_strength = mean(opposition_strength_overall),
                                   results_opposition_attack = mean(opposition_attack),
                                   results_opposition_defense = mean(opposition_defence))

# Fixtures Data =================================================================
# This section aggregates each data frame ready to be used
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Prepare data frames
  df_upcoming_fixtures_h <- df_upcoming_fixtures[c("season_name",
                                                   "gameweek",
                                                   "team_h_id",
                                                   "team_h_name",
                                                   "team_h_strength_overall",
                                                   "team_h_attack",
                                                   "team_h_defence",
                                                   "team_a_strength_overall",
                                                   "team_a_attack",
                                                   "team_a_defence")]
  
  df_upcoming_fixtures_a <- df_upcoming_fixtures[c("season_name",
                                                   "gameweek",
                                                   "team_a_id",
                                                   "team_a_name",
                                                   "team_a_strength_overall",
                                                   "team_a_attack",
                                                   "team_a_defence",
                                                   "team_h_strength_overall",
                                                   "team_h_attack",
                                                   "team_h_defence")]
  
  df_upcoming_fixtures_h <- data.frame(setNames(df_upcoming_fixtures_h,
                                                c("season_name",
                                                  "gameweek",
                                                  "team_id",
                                                  "team_name",
                                                  "team_strength_overall",
                                                  "team_attack",
                                                  "team_defence",
                                                  "opposition_strength_overall",
                                                  "opposition_attack",
                                                  "opposition_defence")))
  
  df_upcoming_fixtures_a <- data.frame(setNames(df_upcoming_fixtures_a,
                                                c("season_name",
                                                  "gameweek",
                                                  "team_id",
                                                  "team_name",
                                                  "team_strength_overall",
                                                  "team_attack",
                                                  "team_defence",
                                                  "opposition_strength_overall",
                                                  "opposition_attack",
                                                  "opposition_defence")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Bind dataframes
  df_upcoming_fixtures <- rbind(df_upcoming_fixtures_h,
                                df_upcoming_fixtures_a)
  
  rm(df_upcoming_fixtures_h,
     df_upcoming_fixtures_a)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Sort data
  df_upcoming_fixtures <- df_upcoming_fixtures[order(df_upcoming_fixtures$season_name,
                                                     df_upcoming_fixtures$gameweek,
                                                     df_upcoming_fixtures$team_id) , ]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Aggregate data
  df_upcoming_fixtures <- df_upcoming_fixtures %>%
                          group_by(season_name,
                                   team_id,
                                   team_name) %>%
                          summarize(fixtures_team_fixtures = n(),
                                    fixtures_team_strength = mean(team_strength_overall),
                                    fixtures_team_attack = mean(team_attack),
                                    fixtures_team_defense = mean(team_defence),
                                    fixtures_opposition_strength = mean(opposition_strength_overall),
                                    fixtures_opposition_attack = mean(opposition_attack),
                                    fixtures_opposition_defense = mean(opposition_defence))

# Remove Data Frames ===========================================================
# This section removes data frames that are no longer required
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  rm(df_player_selection_fixtures)