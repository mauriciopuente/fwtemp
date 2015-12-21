#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

#echo "Loading the Agent..."

#'/usr/local/sbin/Double-Click To Start Support Session.app/Contents/MacOS/sdcust'

#launchctl load -F /Library/LaunchDaemons/com.filewave.bomgar.plist

echo "Changing Permissions and ownership..."

cd /Library/LaunchAgents
chown root:wheel com.filewave.bomgar_user.plist
chmod 644 com.filewave.bomgar_user.plist

cd /Library/LaunchDaemons
chown root:wheel com.filewave.bomgar.plist
chmod 644 com.filewave.bomgar.plist

echo "Loading the Agent..."

launchctl load -F /Library/LaunchAgents/com.filewave.bomgar_user.plist



#temp=$(dscl . list /Users | grep -v ^_.*)

#'/Applications/Double-Click To Start Support Session.app/Contents/MacOS/sdcust'


#sleep 3

#adjust LaunchAgent permissions

#for i in $temp
#do
#	echo "Loooking for the File here:"
#       	echo "/Users/${i}/Library/LaunchAgents/"
#	if [ -f /Users/${i}/Library/LaunchAgents/more.bomgar.plist ]
#
#	then
#     	echo "Yes, The File is there"
#		echo "Fixing File Permissions ... "
#		chown root:wheel /Users/${i}/Library/LaunchAgents/more.bomgar.plist
#		chmod 777 /Users/${i}/Library/LaunchAgents/more.bomgar.plist
#		launchctl load /Users/${i}/Library/LaunchAgents/more.bomgar.plist
#		echo ""
#	else
#      	echo "File not found!"
#		echo "Doing nothing ... "
#		echo ""
#	fi
#done

exit 0

