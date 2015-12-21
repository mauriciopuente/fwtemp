#!/bin/bash

#log all to filewave client log
#exec 1>>/var/log/fwcld.log
#exec 2>>/var/log/fwcld.log

#temp=$(dscl . list /Users | grep -v '^_')
temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

echo " ----------------------------------------------- "
echo " "
echo "These are the users on this Computer: "$temp
echo " "
echo " ----------------------------------------------- "
echo " "

#USERNAME=$(who | grep console | sed -e "s/ .*//")
HOMEPAGE="http://www.wradio.com/"

for i in $temp
do
        sudo -u ${i} /usr/bin/defaults write com.google.Chrome HomepageLocation $HOMEPAGE

        sudo -u ${i} /usr/bin/defaults write com.google.Chrome HomepageIsNewTabPage -bool false

	#sudo -u ${i} /usr/bin/defaults write com.google.Chrome RestoreOnStartup 0
	
        sudo -u ${i} /usr/bin/defaults write com.google.Chrome ShowHomeButton -bool true
done

