#!/bin/bash

exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log

defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Possible values: 'WhenScrolling', 'Automatic' and 'Always'

killall Finder

