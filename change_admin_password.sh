#!/bin/bash

exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log


#unix shortname (no spaces)

username=admin

password=12345678


echo "Changing local admin password"
echo "USERNAME $username"

#setting the admin password
dscl . -passwd /Users/$username $password

