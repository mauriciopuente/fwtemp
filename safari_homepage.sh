#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

#temp=$(dscl . list /Users | grep -v '^_')
temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

echo " ----------------------------------------------- "
echo " "
echo "These are the users on this Computer: "$temp
echo " "
echo " ----------------------------------------------- "
echo " "

HOMEPAGE="http://www.youtube.com"

defaults write /System/Library/User\ Template/English.lproj/Library/Preferences/com.apple.Safari HomePage -string $HOMEPAGE

for i in $temp
do
	echo "Setting HomePage for ${i} ..."
	defaults write /Users/${i}/Library/Preferences/com.apple.Safari HomePage -string $HOMEPAGE
	#sudo -u ${i} /usr/bin/defaults write com.apple.Safari HomePage $HOMEPAGE
	
done
