#!/bin/bash

#log all to filewave client log
#exec 1>>/var/log/fwcld.log
#exec 2>>/var/log/fwcld.log

temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")
c=0

for i in $temp
do

    if [ -d /Users/${i}/Library/Application\ Support/Google/Chrome/Default/Extensions/felcaaldnbdncclmgdcncolpebgiejap ]
        then
            c=1
    fi

done

#echo "$c"

if [ "$c" != 0 ]
    then
        echo "True"
    else
        echo "False"
fi
