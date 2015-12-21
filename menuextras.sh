#!/bin/bash

#Hide Wifi Menu Extra



currentUser=$( ls -l /dev/console | awk '{print $3}' )

userHome=$( dscl . read /Users/$currentUser NFSHomeDirectory | awk '{print $NF}' )

Array="/System/Library/CoreServices/Menu Extras/AirPort.menu"

#WiFi=$( defaults read ~/Library/Preferences/com.apple.systemuiserver | grep "AirPort" | sed 's/^[^"]*"//; s/".*//' )

MenuExtras=$( defaults read "/Users/admin/Library/Preferences/com.apple.systemuiserver.plist" menuExtras | awk -F'"' '{print $2}' )

defaults read $userHome/Library/Preferences/com.apple.systemuiserver | grep -i "menu extras" | sed 's/^[^"]*"//; s/".*//' > /fwtemp/wifitmp.txt

IFS=$'\n' read -d '' -r -a lines < /fwtemp/wifitmp.txt 


c=0
tam=${#lines[@]}
#echo $tam
#ans=$(( $tam + 1 ))
#echo $ans

echo " ============================================================================= "
echo " "
echo " ============================================================================= "

for menuExtra in "${lines[@]}"; do
	#printf "position $c --> ${menuExtra}\n"
	
	if [[ $c == $(( $tam - 1 )) ]]
	then
		echo "BYE !!!"
	else
	
		if [[ "${menuExtra}" == *"AirPort"* ]] 
		then
			printf "Found in position $c --> ${menuExtra} ... Deleting ...\n"
			/usr/libexec/PlistBuddy -c "Delete :menuExtras:$c" $userHome/Library/Preferences/com.apple.systemuiserver.plist
			killall cfprefsd
			sleep 2
			killall SystemUIServer
		
			#else
			#echo "I could not find the AirPort Menu Extra ... Please verify."	
		fi
	c=$(( $c+1 ))
		
		
	fi	
done

echo " ============================================================================= "
echo " "
echo " ============================================================================= "


#killall cfprefsd
#sleep 2
#killall SystemUIServer
