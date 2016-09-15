#!/bin/bash

defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool True

defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool True
defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool True
defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool True
defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool True

exit 0
