#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

serials=""

system_profiler SPPowerDataType | grep "Connected: Yes"

if [ $? == 0 ]; then 

serials=$( system_profiler SPPowerDataType |grep "Serial Number" |awk '{print $3}' )

else

serials="Powerbrick not connected!"

fi

echo $serials
sudo /usr/local/sbin/FileWave.app/Contents/MacOS/fwcld -custom_write -key custom_string_01 -value "$serials"
