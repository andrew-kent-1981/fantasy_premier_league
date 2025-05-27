# Script name:  email_confirmation.R
# Written by:   Andrew Kent
# Purpose:      This R script uses the blastula package to automate the process 
#               of composing and sending an email via a specified SMTP server 
#               without requiring authentication. The script installs and loads 
#               the blastula package, sets up email server credentials, creates 
#               the email content (including the body and footer), and then 
#               sends the email.

# Set Up Credentials ===========================================================
# The Set Up Credentials section configures the connection to the SMTP server 
# without requiring authentication.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Setup credentials
  smtp_credentials <- 
    creds_anonymous(host = "10.248.76.50",
                    port = 25,
                    use_ssl = FALSE)

# Create the Email Content =====================================================
# This section defines the email's content, which will be sent to the recipient, 
# ensuring that both the body and footer are included in the message.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Email body.
  email_body <- paste0(
    "<p>Dear Team,</p>",
    
    "<p>The Fantasy Premier League (FPL) data model has been successfully updated. Please find a summary of the update below:</p>",
    
    "<ul>",
    "<li><strong>Data Coverage:</strong> All player statistics and season information up to <strong>", format(Sys.Date(), "%d %B %Y"), "</strong>.</li>",
    "<li><strong>Update Status:</strong> Completed successfully with no errors reported.</li>",
    "</ul>",
    
    "<p><strong>Seasons included in this update:</strong></p>",
    "<table style='border-collapse: collapse; width: 50%; border: 1px solid #ccc;'>",
    "<thead>",
    "<tr><th style='padding: 8px; text-align: left; background-color: #f2f2f2;'>Season</th></tr>",
    "</thead>",
    "<tbody>",
    paste(
      sapply(lst_season_list, function(season) {
        paste0("<tr><td style='padding: 8px; border: 1px solid #ccc;'>", season, "</td></tr>")
      }),
      collapse = ""
    ),
    "</tbody>",
    "</table>",
    
    "<p>Please make sure to reference the latest data in your analysis and dashboards going forward. If you encounter any issues or have questions, feel free to reach out.</p>",
    
    "<p>Best regards,</p>",
    "<p>Andy Kent<br/><em>Fantasy Premier League Analysis Team</em></p>"
  )
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Email footer
  email_footer <- paste(
    "For more information about the Fantasy Premier League data updates, ",
    "please contact [Andrew Kent](andrew.kent@nhs.scot) or visit our ",
    "[Dashboard](https://app.powerbi.com/groups/me/reports/81f9ce99-add8-42c5-bc67-5d3daeb8e2b6/ReportSection?experience=power-bi).",
    sep = ""
  )
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Create email framework.
  email <- 
    compose_email(body = md(email_body),
                  footer = md(email_footer))

# Send Email ===================================================================
# This section automates the actual sending of the email, ensuring that the 
# specified email content is delivered to the recipient without showing any 
# output in the console.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Send email.
  suppressMessages(
    email %>%
      smtp_send(
        to = c("andrew.kent@nhs.scot"),
        from = "fantasy_premier_league.noreply@scotamb.co.uk",
        subject = "Fantasy Premier League Data Update",
        credentials = smtp_credentials))

# Clear Variables ==============================================================
# This section clears all variables used within the script.
# =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
# Clear variables.
  rm(email,
     email_body,
     email_footer,
     smtp_credentials)
