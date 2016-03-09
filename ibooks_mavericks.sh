#!/bin/bash

#log all to filewave client log

exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log

ibooksinstances=$( ps -xa | grep -i "ibooks" | grep -v grep | awk {'print $1'} )

echo "Deleting the iBooks plist ..."
rm -rf /Library/Preferences/com.apple.iBooksX.secure.plist

echo "copying the new plist..."
cp /usr/local/etc/com.apple.iBooksX.secure.plist /Library/Preferences/

if [[ $(echo -n $ibooksinstances | wc -w) -ge 1 ]]; then
    kill -9 $ibooksinstances
fi

exit 0