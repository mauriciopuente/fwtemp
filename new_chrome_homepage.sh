#!/bin/bash

### Chrome ###

	# Define some variables
	homepage="http://www.cnn.com"
	user="admin"
	chromePrefs="/Users/$user/Library/Application Support/Google/Chrome/Default/Preferences"
	sessionLines=$(awk '/session/ {print NR}' "$chromePrefs" | tail -1)
	urlLineNum=$(awk '{print NR,$0}' "$chromePrefs" | grep -A 10 "$sessionLines" | awk '/"startup_urls"/ {print $1}' | awk 'NR==1')
	urlNewLine='"startup_urls": [ '\"${homepage}\"' ]'

	# Set homepage if no homepage is set yet
	if [[ $urlLineNum == "" ]]; then
        	sed -i '' '/restore_on_startup/d' "$chromePrefs"
        	sed -i '' '/startup_urls_migration_time/d' "$chromePrefs"
        	sed -i '' "${sessionLines}"'a\
               		"restore_on_startup": 4,\
                	"startup_urls": [ "http://www.cnn.com" ]\
                	' "$chromePrefs"
        	sed -i '' "s#http://www.cnn.com#$homepage#g" "$chromePrefs"
		echo "No Chrome homepage already set. Set new Chrome homepage to $homepage for $user."

	# Set homepage if there's already one set
	else
        	sed -i '' "${urlLineNum}s#.*#${urlNewLine}#g" "$chromePrefs"
                sed -i '' '/startup_urls_migration_time/d' "$chromePrefs"
		echo "A Chrome homepage already set. Set new Chrome homepage to $homepage for $user."
	fi
