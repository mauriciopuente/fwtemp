#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

echo ""
echo "Mounting the DMG now ..."
echo""

hdiutil attach -mountpoint /Volumes/abletonlive /usr/local/etc/ableton_live_intro_9.7_64.dmg

echo ""
echo "Copying Ableton to the Applications Folder ..."
echo""

cp -Rv "/Volumes/abletonlive/Ableton Live 9 Intro.app" /Applications/

hdiutil unmount "/Volumes/abletonlive"

