#!/bin/bash


#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

echo "Moving HMH Sec Browser to Apps Folder ..."
mv /usr/local/etc/HMH\ Secure\ Browser.app /Applications/

echo "Changing permissions and ownership ..."
chmod 775 /Applications/HMH\ Secure\ Browser.app
chown admin:admin /Applications/HMH\ Secure\ Browser.app

exit 0
