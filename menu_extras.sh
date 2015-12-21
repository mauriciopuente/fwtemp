#!/bin/bash

PreferredMenuExtras=(
"/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"
"/System/Library/CoreServices/Menu Extras/AirPort.menu"
"/System/Library/CoreServices/Menu Extras/Battery.menu"
"/System/Library/CoreServices/Menu Extras/Bluetooth.menu"
"/System/Library/CoreServices/Menu Extras/Clock.menu"
"/System/Library/CoreServices/Menu Extras/Eject.menu"
)

currentUser=$( ls -l /dev/console | awk '{print $3}' )
userHome=$( dscl . read /Users/$currentUser NFSHomeDirectory | awk '{print $NF}' )

MenuExtras=$( defaults read "$userHome/Library/Preferences/com.apple.systemuiserver.plist" menuExtras | awk -F'"' '{print $2}' )

for menuExtra in "${PreferredMenuExtras[@]}"; do
	menuShortName=$( echo "${menuExtra}" | awk -F'/' '{print $NF}' )
	if [[ $( echo "${MenuExtras}" | grep "${menuExtra}" ) ]]; then
		echo "Menu Extra \"${menuShortName}\" present"
	else
		echo "Menu Extra \"${menuShortName}\" not in plist. Opening..."
		open "${menuExtra}"
	fi
done
