ECHO OFF
REM Title:      Uninstall QAI Secure Browser
REM Date:       4/03/2015
REM Author:     Mauricio Puente
REM
REM Purpose:    Script to remove QAI Secure Browser from a computer without user intervention.

msiexec /x C:\temp\fw_temp_msi\QAI_Secure_Browser.msi /quiet
