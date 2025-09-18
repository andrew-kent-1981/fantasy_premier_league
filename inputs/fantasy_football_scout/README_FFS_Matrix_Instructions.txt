README: Instructions for Updating the Fantasy Football Scout Matrix

Purpose:
The purpose of this matrix is to link together official Fantasy Premier League (FPL) data with Fantasy Football Scout (FFS) data. The challenge is that FFS data does not contain a unique ID and player names may be spelled differently. This matrix joins the two datasets but must be manually checked and maintained.

Steps to Update the Matrix:

1. Download the FFS player data from:
   https://rate-my-team.fantasyfootballscout.co.uk/players/

2. Paste the downloaded data into the CSV file located at:
   D:\sas_business_intelligence\sas_bi_clinical_outcomes\r_projects\fantasy_premier_league\inputs\fantasy_football_scout\fantasy_football_scout_rate_my_team

3. Open the matrix file located at:
   D:\sas_business_intelligence\sas_bi_clinical_outcomes\r_projects\fantasy_premier_league\inputs\fantasy_football_scout\fantasy_football_scout_matrix

4. Refresh the matrix file.

5. Check the 'missing_player_check' tab for any missing players.

6. Locate the missing players on the 'data_fantasy_football_scout' tab.

7. Copy the relevant data from both the 'missing_player_check' tab and the 'data_fantasy_football_scout' tab.

8. Paste this data into the 'player_linkage' tab.

9. Refresh the matrix file again.

10. Verify that the 'final_data' tab displays both FPL and FFS data linked together.

11. Save the updated matrix file.

End of Instructions.
