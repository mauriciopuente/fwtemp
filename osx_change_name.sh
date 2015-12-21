#!/bin/sh
#Created 02/2015 by Darcey Steinsberger @ FileWave


serial=$( system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' )
name=$( cat /usr/local/etc/naming.csv | grep $serial | awk -F, '{print $2}' )

echo $name

#/usr/sbin/scutil --set ComputerName $name
#/usr/sbin/scutil --set LocalHostName $name
#/usr/sbin/scutil --set HostName $name


#restart fwcld for changes to take effect
#/sbin/fwcontrol client restart

#exit 0
