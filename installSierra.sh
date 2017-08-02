#!/bin/bash
# start the installation without prompting the user, towards 
/Applications/Install\ macOS\ Sierra.app/Contents/Resources/startosinstall --rebootdelay 10 --nointeraction --volume / --applicationpath /Applications/Install\ macOS\ Sierra.app 
# we have to make sure the startosinstall task can actually initiate it's soft reboot
# therefore we have to sleep until it can do it's job - otherwise fwcld will reboot before
sleep 60
exit 0
