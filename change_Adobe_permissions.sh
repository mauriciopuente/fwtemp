#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

cd /Library/Application\ Support/Adobe

ls -lah | grep -i "SLStore"
ls -lah | grep -i "PCD"

chmod 777 SLStore
chmod 755 Adobe\ PCD

ls -lah | grep -i "SLStore"
ls -lah | grep -i "PCD"

