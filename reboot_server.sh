#!/bin/bash

fwxserverinstances=$(ps -xa | grep -i "fwxserver -a" | grep -v grep | awk {'print $1'})

fwcontrol server stop
sleep 5

if [[ $(echo -n $fwxserverinstances | wc -w) -gt 0 ]]; then
        echo "FWXserver -admin is still running, Restarting the Filewave Services Again..."
        fwcontrol server stop
fi

shutdown -r now

