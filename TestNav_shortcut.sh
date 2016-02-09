#!/bin/bash

#log all to filewave client log

exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")


for i in $temp

do

echo "Creating the TestNav shortcut for ${i} ..."
ln -s /Applications/TestNav.app /Users/${i}/Desktop/

#sudo -u ${i} /usr/bin/defaults write com.apple.Safari HomePage $HOMEPAGE
done