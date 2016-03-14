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

######################### ENVIRONMENT VARIABLES #######################

# Get the Hardware UUID from system profiler
uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)

echo "$uuid"

####################### DO NOT MODIFY BELOW THIS LINE #################


# Write the UUID to the hidden plist file and initialise it

/usr/bin/defaults write /Users/admin/Library/Preferences/ByHost/com.apple.screensaver."$uuid" idleTime -int 0