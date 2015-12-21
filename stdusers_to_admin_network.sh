#!/bin/bash

#log all to filewave client log
exec 1>>/var/log/fwcld.log
exec 2>>/var/log/fwcld.log

security authorizationdb write system.preferences allow

security authorizationdb read  system.preferences.network > /tmp/system.preferences.network.plist

defaults write /tmp/system.preferences.network.plist group everyone
# This grants access to the "everyone" group. this could be any group.

defaults write /tmp/system.preferences.network.plist authenticate-user -bool false

security authorizationdb write system.preferences.network < /tmp/system.preferences.network.plist
