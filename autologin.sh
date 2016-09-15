#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

defaults write /Library/Preferences/com.apple.loginwindow "autoLoginUser" 'NCTemp'
