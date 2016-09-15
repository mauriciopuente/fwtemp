#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

echo "Turning the SSH daamon ON ..."

systemsetup -setremotelogin on


