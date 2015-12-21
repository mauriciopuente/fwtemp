#!/bin/bash

USERNAME=$(who | grep console | sed -e "s/ .*//")
HOMEPAGE="http://www.gmail.com/"

sudo -u $USERNAME /usr/bin/defaults write com.apple.Safari HomePage $HOMEPAGE
