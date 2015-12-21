#!/usr/bin/expect -f
spawn /Library/Application\ Support/Sophos/opm/Installer.app/Contents/MacOS/tools/InstallationDeployer --remove
expect "assword:"
send "Danbury@123\r"
interact
