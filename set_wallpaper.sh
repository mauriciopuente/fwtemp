#!/bin/bash

#Set Wallpaper

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

for i in $temp

	do

		rm -rf /Users/${i}/Library/Application\ Support/Dock/desktoppicture.db

	done

exit 0
