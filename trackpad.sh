#!/bin/bash

########################## SET SYSTEM TIME  ##################################################
#
# This script does the following:
#
#
# 1. Get the hardware UUID of the machine and put it in the location services db
# 2. Sets the screen saver to never run
#
#
###############################################################################################

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

######################### ENVIRONMENT VARIABLES #################################################

# Get the Hardware UUID from system profiler
uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)

echo "$uuid"

####################### DO NOT MODIFY BELOW THIS LINE ############################################


# Write the UUID to the hidden plist file and initialise it

for i in $temp
do
	sudo -u ${i} /usr/bin/defaults write /Users/${i}/Library/Preferences/ByHost/com.apple.screensaver."$uuid".plist idleTime -int 0
done