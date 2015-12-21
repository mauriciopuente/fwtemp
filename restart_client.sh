#!/bin/sh

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

fwcontrol client restart

sleep 5

fwcldinstances=$(ps -xa |grep -i "fwcld" |grep -v grep |awk {'print $1'})
if [ $(echo -n $fwcldinstances | wc -w) -ge 1 ]; then
echo "FW Client running"
else
		echo "FW Client running, therefore Forcing FWCLD start"
		fwcontrol client start
fi

exit 0