#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

consoleuser=$( who | grep console | sed -e "s/ .*//" )

sudo -u$consoleuser whoami

echo ""
echo "Disabling Notification Center..."
echo ""

sudo -u$consoleuser launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
