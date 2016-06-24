#!/bin/bash

time=$( /usr/bin/uptime )

admins=''

for i in $time
do
	admins=$admins' '$i
done

echo $admins
