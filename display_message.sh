#!/bin/bash

#log all to filewave client log
#exec 1>>/var/log/fwcld.log
#exec 2>>/var/log/fwcld.log

osascript <<EOF
tell application "Finder"
activate
## THE NEXT ONE IS THE ONLY LINE YOU SHOULD CHANGE
set userresult to (display dialog "Sorry, this operation is not supported" buttons {"OK"} default button 1 with icon 0 with title "Operation not Supported")
## DO NOT CHANGE ANYTHING BELOW HERE
end tell
EOF


