#!/bin/bash

security authorizationdb read  system.preferences.energysaver > /tmp/system.preferences.energysaver.plist

defaults write /tmp/system.preferences.energysaver.plist group everyone
# This grants access to the "everyone" group. this could be any group.

security authorizationdb write system.preferences.energysaver < /tmp/system.preferences.energysaver.plist
