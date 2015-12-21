#!/bin/bash

PROCESS=fwxserver
fwxserverinstances=$(ps -xa | grep -i "fwxserver" | grep -v grep | awk {'print $1'})
apacheinstances=$(ps -xa | grep -i "httpd" | grep -i "filewave" | grep -v grep | awk {'print $1'})

if [[ $(echo -n $fwxserverinstances | wc -w) -lt 3 ]] || [[ $(echo -n $apacheinstances | wc -w) -lt 4 ]]; then
	echo Something is wrong, Restarting the Filewave Services ... ;
	fwcontrol server stop
	sleep 5
	fwcontrol server start
   else
	echo FWXserver and Apache are Running;
fi


