#!/bin/bash

#log all to filewave client log
#exec 1>>/var/log/fwcld.log
#exec 2>>/var/log/fwcld.log


if [ -d "/Applications/Firefox.app/Contents/Resources/defaults/pref" ]
	then
			echo "Directory is there. Creating local-settings.js ..."
			cd /Applications/Firefox.app/Contents/Resources/defaults/pref
			
			echo 'pref("general.config.filename", "mozilla.cfg");' >> local-settings.js
			echo 'pref("general.config.obscure_value", 0);' >> local-settings.js
			
			chmod 644 local-settings.js
			chown admin:admin local-settings.js
			
			
			echo "Creating Config File ..."
			cd /Applications/Firefox.app
			#echo 'pref("browser.rights.3.shown", true);' >> mozilla.cfg
			echo 'lockPref("app.update.enabled", false);' >> mozilla.cfg
			
			
			chmod 644 mozilla.cfg
			chown admin:admin mozilla.cfg
else
	echo 'No Firefox installation Found ... Bye! '
	
fi

