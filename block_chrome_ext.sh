#!/bin/bash

#log all to filewave client log

exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

for i in $temp

do

# remove the google extensions directory

rm -rf "/Users/${i}/Library/Application Support/Google/Chrome/Default/Extensions"

# recreate the google extensions directory

mkdir "/Users/${i}/Library/Application Support/Google/Chrome/Default/Extensions"

# change the permissions on the folder

chmod -R 444 "/Users/${i}/Library/Application Support/Google/Chrome/Default/Extensions"

done