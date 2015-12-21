#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log


temp=$(ls /Users | grep -v ".localized" | grep -v "Shared")

for i in $temp
do

if ! [[ $COMMAND_LINE_INSTALL && $COMMAND_LINE_INSTALL != 0 ]]
then
register_trusted_cmd="/usr/bin/sudo -u ${i} /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted"
application="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"

    if /bin/test -d "$application"
        then
        $register_trusted_cmd "$application"
    fi
fi

done

exit 0