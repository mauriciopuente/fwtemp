#!/bin/sh

FWCONTROL=/sbin/fwcontrol

# stopping all daemons
if [ -x $FWCONTROL ]; then
	$FWCONTROL fwgui stop
	$FWCONTROL client stop
fi

# removing launchd plists
rm -f /Library/LaunchAgents/com.filewave.fwGUI.plist
rm -f /Library/LaunchAgents/com.filewave.fwVNCServer.plist
rm -f /Library/LaunchAgents/com.filewave.fwVNCServer.plist.bak

rm -f /Library/LaunchDaemons/com.filewave.fwcld.plist


# removing old start methods
rm -f /System/Library/StartupItems/FWClient


rm -rf /usr/local/sbin/FileWave.app

# cleaning up folders used by FileWave

rm -f /usr/local/etc/fwcld.plist

rm -rf /private/var/log/fwcld.log

sudo killall fwGUI
