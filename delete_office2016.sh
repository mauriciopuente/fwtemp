#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

temp=$( ls /Users | grep -v ".localized" | grep -v "Shared" )

rm -rf /Applications/Microsoft*

for i in $temp
do

	rm -rf /Users/${i}/Library/Preferences/com.microsoft.Excel.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.office.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.office.setupassistant.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.outlook.databasedaemon.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.outlook.office_reminders.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.Outlook.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.PowerPoint.plist
	rm -rf /Users/${i}/Library/Preferences/com.microsoft.Word.plist

    echo "Deleting files from /Users/${i}/Library/Preferences/ByHost/ ..."
	rm -rf /Users/${i}/Library/Preferences/ByHost/com.microsoft*

	rm -rf /Users/${i}/Library/Application\ Support/Microsoft

	rm -rf /Users/${i}/Documents/Microsoft\ User\ Data

done


rm -rf /Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist

rm -rf /Library/Preferences/com.microsoft.office.licensing.plist

rm -rf /Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper

rm -rf "/Library/Application Support/Microsoft"

rm -rf /Library/Fonts/Microsoft

echo "Deleting files from /Library/Receipts ..."
rm -rf /Library/Receipts/Office2016*

killall Dock




