#!/bin/bash

sudo find /private/var/folders -name com.apple.dock.launchpad|xargs -Irepl sudo find repl/db/db| xargs -Irepl sudo sqlite3 repl "DELETE FROM apps WHERE title='Client Assistant';" && sudo killall Dock

sudo rm -rf /usr/local/sbin/Client\ Assistant.app #removes the app
