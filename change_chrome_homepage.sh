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

echo "We will look for the directory in the following places:"
for i in $temp
do
	echo "/Users/${i}/Library/Application Support/Google/Chrome/Default"
done 
echo " "
echo " ----------------------------------------------- "
echo " "

for i in $temp
do
	echo "Loooking for the Directory here:"
        echo "/Users/${i}/Library/Application Support/Google/Chrome/Default"
	if [ -d /Users/${i}/Library/Application\ Support/Google/Chrome/Default ]

	then
        	echo "Yes, The Directory is there"
		echo "Changing Preferences File ... "
		cd /Users/${i}/Library/Application\ Support/Google/Chrome/Default
		mv Preferences Preferences.OLD
		cp /usr/local/etc/Preferences /Users/${i}/Library/Application\ Support/Google/Chrome/Default/
		echo ""
	else
        	echo "Directory not found!"
		echo "Doing nothing ... "
		echo ""
	fi
done