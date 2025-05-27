# Script name:  output_results_analysis.R
# Written by:   Andrew Kent
# Purpose:      This script creates an extract file for results to be used 
#               within analysis

# FPL Managers & League IDs ====================================================
# This section determines the IDs of each manager and the league they play in.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load manager ids
  df_manager_ids <- read_excel(paste(str_location_master,
                                     "inputs",
                                     "manager_ids.xlsx", 
                                     sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Keep relevant data
  df_manager_ids <- df_manager_ids[c("id",
                                     "name",
                                     "season")]
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Rename variables
  df_manager_ids <- data.frame(setNames(df_manager_ids,
                                        c("manager_id",
                                         "manager_name",
                                         "season_name")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Correct season name
  df_manager_ids$season_name <- paste("20",
                                      str_sub(df_manager_ids$season_name, start = 8,  end = 9),
                                      "/",
                                      str_sub(df_manager_ids$season_name, start = 11,  end = 12),
                                      sep = "")

# Import Fixtures ==============================================================
# This section imports the manual fixtures data and prepares the data frame
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Load fixtures
  df_fixtures <- read_excel(paste(str_location_master,
                                  "inputs",
                                  "fixtures.xlsx", 
                                  sep = "/"))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove missing fixtures
  df_fixtures <- subset(df_fixtures,
                        is.na(df_fixtures$home_team_id) == FALSE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove variables
  df_fixtures$h_team <- NULL
  df_fixtures$a_team <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create scores data frame
  df_scores_h <- df_fixtures[c("gameweek",
                               "season",
                               "game_type",
                               "round",
                               "home_team_id")]
  
  df_scores_h <- data.frame(setNames(df_scores_h,
                                     c("gameweek",
                                       "season_name",
                                       "competition",
                                       "round",
                                       "manager_id")))
  
  df_scores_a <- df_fixtures[c("gameweek",
                               "season",
                               "game_type",
                               "round",
                               "away_team_id")]
  
  df_scores_a <- data.frame(setNames(df_scores_a,
                                     c("gameweek",
                                       "season_name",
                                       "competition",
                                       "round",
                                       "manager_id")))
  
  df_scores <- rbind(df_scores_h,
                     df_scores_a)
  
  rm(df_scores_h,
     df_scores_a)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Add player names
  df_scores <- merge(df_scores, 
                     df_manager_ids, 
                     by.x = c("manager_id","season_name"),
                     by.y = c("manager_id","season_name"), 
                     all.x = TRUE)
  
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
                      	fpl_ownership_data.id AS manager_id,
                      	fpl_ownership_data.gameweek AS gameweek,
                      	fpl_ownership_data.season_name AS season_name,
                      	fpl_ownership_data.element AS player_id,
                      	fpl_ownership_data.position AS position,
                      	fpl_ownership_data.multiplier AS multiplier,
                      	fpl_gameweeks_data.total_points AS points
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_ownership_data] AS fpl_ownership_data
                      	LEFT OUTER JOIN [Clinical_Outcomes_Analysis].[dbo].[fpl_gameweeks_data] AS fpl_gameweeks_data
                      		ON (
                      			fpl_ownership_data.element = fpl_gameweeks_data.player_id
                      			AND
                      			fpl_ownership_data.gameweek = fpl_gameweeks_data.gameweek
                      			AND
                      			fpl_ownership_data.season_name = fpl_gameweeks_data.season_name
                      			)
                      ORDER BY
                      	fpl_ownership_data.season_name,
                      	fpl_ownership_data.gameweek,
                      	fpl_ownership_data.id,
                      	fpl_ownership_data.position ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_gameweek_points <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
  # =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
  # Create SQL query
  sql_query <- paste("-- RStudio Process -- Andrew Kent
                      SELECT
                      	fpl_manager_current_season_data.event AS gameweek,
                      	fpl_manager_current_season_data.season_name AS season_name,
                      	fpl_manager_current_season_data.id AS manager_id,
                      	fpl_manager_current_season_data.event_transfers_cost AS transfers_cost,
                      	fpl_manager_current_season_data.points AS gameweek_points
                      FROM
                      	[Clinical_Outcomes_Analysis].[dbo].[fpl_manager_current_season_data] AS fpl_manager_current_season_data
                      ORDER BY
                      	fpl_manager_current_season_data.season_name,
                      	fpl_manager_current_season_data.event,
                      	fpl_manager_current_season_data.id ASC",
                     sep = "")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Query database
  sql_result <- dbSendQuery(db_connection_cod, 
                            sql_query)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Return query
  df_gameweek_summary <- dbFetch(sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear results
  dbClearResult(sql_result)
  
  rm(sql_query,
     sql_result)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Disconnect from database and remove variables
  dbDisconnect(db_connection_cod)
  
  rm(db_connection_cod)
  
# Prepare Points Data ==========================================================
# This section calculates the points for each gameweek for league and cup games
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Calculate league and cup points
  df_gameweek_points$league_points <- df_gameweek_points$points * df_gameweek_points$multiplier
  df_gameweek_points$cup_multiplier <- ifelse(df_gameweek_points$multiplier > 1,
                                              1,
                                              df_gameweek_points$multiplier)
  df_gameweek_points$cup_points <- df_gameweek_points$points * df_gameweek_points$cup_multiplier
  
  df_gameweek_points$cup_multiplier <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# create league and cup data frames
  df_gameweek_points_league <- df_gameweek_points %>%
                               group_by(manager_id,
                                        gameweek,
                                        season_name) %>%
                               summarize(league_points = sum(league_points))
  
  df_gameweek_points_cup <- df_gameweek_points %>%
                            group_by(manager_id,
                                     gameweek,
                                     season_name) %>%
                            summarize(cup_points = sum(cup_points))
  
  df_gameweek_points_league$competition <- "League"
  df_gameweek_points_cup$competition <- "Cup"
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data frames
  rm(df_gameweek_points)
  
# Merge Data Frames ============================================================
# This section merges the data frames into one master frame
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge summary
  df_scores <- merge(df_scores, 
                     df_gameweek_summary, 
                     by.x = c("manager_id","season_name","gameweek"),
                     by.y = c("manager_id","season_name","gameweek"), 
                     all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge league
  df_scores <- merge(df_scores, 
                     df_gameweek_points_league, 
                     by.x = c("manager_id","season_name","gameweek","competition"),
                     by.y = c("manager_id","season_name","gameweek","competition"), 
                     all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge cup
  df_scores <- merge(df_scores, 
                     df_gameweek_points_cup, 
                     by.x = c("manager_id","season_name","gameweek","competition"),
                     by.y = c("manager_id","season_name","gameweek","competition"), 
                     all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data frames
  rm(df_gameweek_summary,
     df_gameweek_points_league)
  
# Tidy Data Frame ==============================================================
# This section tidies the df_scores data frame ready for final use
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# apply transfer cost
  df_scores$gameweek_points <- ifelse(df_scores$competition %in% "League",
                                      df_scores$league_points - df_scores$transfers_cost,
                                      df_scores$cup_points - df_scores$transfers_cost)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove variables
  df_scores$league_points <- NULL
  df_scores$cup_points <- NULL
  df_scores$transfers_cost <- NULL
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Organize variables
  df_scores <- df_scores[c("season_name",
                           "gameweek",
                           "competition",
                           "round",
                           "manager_id",
                           "manager_name",
                           "gameweek_points")]
  
# Finalise Fixtures Data =======================================================
# This section finalzies the fixtures data frame ready for analysis
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Home scores
  df_scores_h <- df_scores[c("manager_id",
                             "manager_name",
                             "gameweek",
                             "season_name",
                             "competition",
                             "gameweek_points")]
  
  df_scores_h <- data.frame(setNames(df_scores_h,
                                     c("manager_id",
                                       "home_team",
                                       "gameweek",
                                       "season_name",
                                       "competition",
                                       "home_score")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Away scores
  df_scores_a <- df_scores[c("manager_id",
                             "manager_name",
                             "gameweek",
                             "season_name",
                             "competition",
                             "gameweek_points")]
  
  df_scores_a <- data.frame(setNames(df_scores_h,
                                     c("manager_id",
                                       "away_team",
                                       "gameweek",
                                       "season_name",
                                       "competition",
                                       "away_score")))
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge home scores
  df_fixtures <- merge(df_fixtures, 
                       df_scores_h, 
                       by.x = c("home_team_id","season","gameweek","game_type"),
                       by.y = c("manager_id","season_name","gameweek","competition"), 
                       all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Merge away scores
  df_fixtures <- merge(df_fixtures, 
                       df_scores_a, 
                       by.x = c("away_team_id","season","gameweek","game_type"),
                       by.y = c("manager_id","season_name","gameweek","competition"), 
                       all.x = TRUE)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Remove data frames
  rm(df_scores_h,
     df_scores_a)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Add vrs
  df_fixtures$vrs <- "v"
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Organize variables
  df_fixtures <- df_fixtures[c("season",
                               "gameweek",
                               "game_type",
                               "round",
                               "home_team_id",
                               "home_team",
                               "home_score",
                               "vrs",
                               "away_score",
                               "away_team",
                               "away_team_id")]

# Extract Data =================================================================
# This section creates a .csv extract
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Extract results
  write.table(df_fixtures,
              file = paste(str_location_master,
                           "/outputs/",
                           "fpl_results.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Extract results
  write.table(df_fixtures,
              file = paste(str_location_master,
                           "/outputs/",
                           "fpl_gameweek_scores.csv", 
                           sep=""),
              row.names = FALSE,
              col.names = TRUE, 
              na = "",
              sep = ",")

# Clear Variables ==============================================================
# This section clears the variables that are no longer required
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear variables
  rm(df_fixtures,
     df_scores)
