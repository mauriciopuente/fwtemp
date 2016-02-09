ECHO OFF
REM Title:      Uninstall CTB Secure Testing App
REM Date:       1/08/2015
REM Author:     Mauricio Puente
REM
REM Purpose:    Script to remove CTB Secure Testing App from a computer without user intervention.

msiexec /x C:\temp\fw_temp_msi\install_ga_sta.msi /quiet
