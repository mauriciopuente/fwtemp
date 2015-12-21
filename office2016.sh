#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

#Find Current User
CurrentUser=`/usr/bin/who | awk '/console/{ print $1 }'`

#Set Command Variable for trusted application
register_trusted_cmd="/usr/bin/sudo -u $CurrentUser
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister
-R -f -trusted"

#Set Variable for application being run against
application="/Library/Application Support/Microsoft/MAU2.0/Microsoft
AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"

#This runs the combination of variables above that will block the running
#of the autoupdate.app until the user actually clicks on it, or goes
#into the help check for updates menu. Additionally this needs to be
#run for each user on a machine.
$register_trusted_cmd "$application"





#Turns off First Run secondary
/usr/bin/defaults delete com.microsoft.Word
kSubUIAppCompletedFirstRunSetup1507
/usr/bin/defaults delete com.microsoft.Outlook
kSubUIAppCompletedFirstRunSetup1507
/usr/bin/defaults delete com.microsoft.PowerPoint
kSubUIAppCompletedFirstRunSetup1507
/usr/bin/defaults delete com.microsoft.Excel
kSubUIAppCompletedFirstRunSetup1507
/usr/bin/defaults delete com.microsoft.onenote.mac
kSubUIAppCompletedFirstRunSetup1507

#Turns off the FirstRunScreen for each application.
/usr/bin/defaults write /Library/Preferences/com.microsoft.Outlook
kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.PowerPoint
kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Excel
kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.Word
kSubUIAppCompletedFirstRunSetup1507 -bool true
/usr/bin/defaults write /Library/Preferences/com.microsoft.onenote.mac
kSubUIAppCompletedFirstRunSetup1507 -bool true

#Turns Off Auto Update
/usr/bin/defaults write com.microsoft.autoupdate2 HowToCheck Manual


# Disable Ugly Microsoft Features...
# Within USER_TEMPLATEs
for USER_TEMPLATE in "/System/Library/User Template"/*
do
#Turn off Telemetry
defaults write
"${USER_TEMPLATE}/Library/Preferences/com.microsoft.autoupdate.fba.plist"
SendAllTelemetryEnabled -bool false
done
# Within USERs
for USER in "/Users"/*
do
#Turn off Telemetry
defaults write
"${USER}/Library/Preferences/com.microsoft.autoupdate.fba.plist"
SendAllTelemetryEnabled -bool false
done


exit 0