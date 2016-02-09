#!/bin/bash

PROCESS=fwxserver
fwxserverinstances=$(ps -xa | grep -i "fwxserver" | grep -v grep | awk {'print $1'})
apacheinstances=$(ps -xa | grep -i "httpd" | grep -i "filewave" | grep -v grep | awk {'print $1'})


fwxserverinstances_a=$(ps -xa | grep -i "fwxserver -a" | grep -v grep | awk {'print $1'})


fwcontrol server stop
sleep 5

if [[ $(echo -n $fwxserverinstances_a | wc -w) -gt 0 ]]; then
        echo "FWXserver -admin is still running, Restarting the Filewave Services Again..."
        fwcontrol server stop
fi

fwcontrol server start
sleep 15


if [[ $(echo -n $fwxserverinstances | wc -w) -lt 3 ]] || [[ $(echo -n $apacheinstances | wc -w) -lt 3 ]]; then
        echo Something is wrong, Restarting the Filewave Services ... ;
        fwcontrol server stop
        sleep 5
	fwcontrol server stop
        sleep 5
        fwcontrol server start
   else
        echo FWXserver and Apache are Running;
fi
