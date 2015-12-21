#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

#Set Variables
odAdmin="diradmin"
odPass="password"
odDomain="glappserv.mcs.k12.ms.us"

#UNBIND FROM OD
dsconfigldap -f -r "$odDomain" -u "$odAdmin" -p "$odPass"
sleep 60

rm -rf /usr/local/etc/scripts/unbind_from_OD.sh

exit 0

