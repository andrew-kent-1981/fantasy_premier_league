# Script name:  obsidian_integration.R
# Written by:   Andrew Kent
# Purpose:      This script automates the generation of Markdown files 
#               from R scripts, dynamically retrieves the active Windows 
#               username, manages file paths, and ensures compatibility with 
#               Obsidian vault workflows, including listing and deleting 
#               specific files in target directories.

# Set Location =================================================================
# This section sets the location of the scripts as the scripts will be run on a
# schedule which will not use the project environment and will be run in base R.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Set R project name.
  str_project_name_r <-
    str_project_name %>% 
    tolower() %>% 
    gsub(" ", "_", .)
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Set master locations.
  str_location_obsidian <- 
    file.path("C:/Users/E9886503/OneDrive - NHS Scotland",
              "Obsidian/clinical_outcomes_vault/Projects",
              str_project_name,
              "R Scripts")
  
  str_location_r <- 
    file.path("//BUSINT-TS1/sas_business_intelligence",
              "sas_bi_clinical_outcomes/r_projects",
              str_project_name_r,
              "scripts")
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Check if the directory exists
  if (dir.exists(str_location_obsidian)) 
    {
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   List all files in the directory
    lst_files_to_delete <- 
      list.files(path = str_location_obsidian, 
                        full.names = TRUE)
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Delete the files
    file.remove(lst_files_to_delete)
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Clear variables.
    rm(lst_files_to_delete)
    }
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear variables.
  rm(str_project_name,
     str_project_name_r)

# List .R Files in a Folder ===================================================
# This section lists all .R files in a specified folder.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Get a list of all .R files in the folder
  lst_script_names <- 
    list.files(path = str_location_r, 
               pattern = "\\.(R|Rmd)$",
               full.names = FALSE)
  
# Create Function ==============================================================
# This section creates a function that will create markdown files for each .R 
# file in a specified location.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Setup function.
  fun_run_obsidian_extract <-
    function(fun_windows_username,
             fun_location_r,
             fun_location_obsidian,
             fun_active_script)
    {
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Set markdown file name.
      fun_active_script_md <- 
        fun_active_script %>% 
        gsub("\\.R$", "", .) %>%
        gsub("~", "", .) 
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Set file paths.
    location_r <- 
      file.path(fun_location_r,
                fun_active_script)
    
    location_obsidian <- 
      file.path(fun_location_obsidian,
                paste(fun_active_script_md,".md", sep = ""))
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Metadata values.
    metadata_title <- fun_active_script_md
    metadata_date <- format(Sys.Date(), "%Y-%m-%d")
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Metadata template.
    metadata <- 
      paste0("---\n",
             "title: ", metadata_title, "\n",
             "date: ", metadata_date, "\n",
             "tags:\n",
             "  - r\n",
             "  - code\n",
             "type: note\n",
             "---\n",
             "# ", metadata_title, "\n",
             "# Date: ", metadata_date, "\n\n",
             "---\n",
             "# Code\n")
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Read the R script.
    markdown_file <- readLines(location_r)
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Combine metadata with script content.
    markdown_content <- c(metadata, "```r", markdown_file, "```")
#   =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
#   Only write the Markdown file if the Windows username matches "E9886503".
    if (fun_windows_username == "E9886503") 
      {
      writeLines(markdown_content, location_obsidian)
      }
    }
  
# Create Markdown Files ========================================================
# This section creates each markdown
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Run the active script.
  for (str_active_script in lst_script_names)
  {
    fun_run_obsidian_extract(fun_windows_username = str_windows_username,
                             fun_location_r = str_location_r,
                             fun_location_obsidian = str_location_obsidian,
                             fun_active_script = str_active_script)
    rm(str_active_script)
  }

# Clear Variables ==============================================================
# This section clears all variables that are no longer needed.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear Variables
  rm(fun_run_obsidian_extract,
     str_windows_username,
     str_location_r,
     str_location_obsidian,
     lst_script_names)
