#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

temp=$(dscl . list /Users | grep -v '^_')

echo " ----------------------------------------------- "
echo " "
echo "These are the users on this Computer: "$temp
echo " "
echo " ----------------------------------------------- "
echo " "


for i in $temp
do
	echo "Change settings for user ${i}"
	echo " "
	sudo -u ${i} /usr/bin/defaults write com.apple.speech.synthesis.general.prefs 'SpokenUIUseSpeakingHotKeyFlag' -bool true

done
