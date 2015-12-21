#!/bin/bash

#log all to filewave client log

exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log


currentUser=$( ls -l /dev/console | awk '{print $3}' )

sudo -u $currentUser installer -pkg /Users/admin/Downloads/MonitorInstall.pkg -target /

#sudo -u $currentUser installer -pkg /Users/admin/Downloads/MonitorInstall.pkg


