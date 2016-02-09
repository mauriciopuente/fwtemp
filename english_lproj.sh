#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

rm -rf /System/Library/User\ Template/English.lproj
rsync -av /usr/local/etc/English.lproj /System/Library/User\ Template

