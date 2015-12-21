#!/bin/sh

FWCONTROL=/sbin/fwcontrol
PG_CTL=/usr/local/filewave/postgresql/bin/pg_ctl
APACHECTL=/usr/local/filewave/apache/bin/apachectl

# stopping all daemons
if [ -x $FWCONTROL ]; then
	$FWCONTROL fwgui stop
	$FWCONTROL client stop
	$FWCONTROL booster stop
	$FWCONTROL server stop
fi

[ -x $APACHECTL ] && $APACHECTL stop
[ -x $PG_CTL ] && sudo -u postgres -s "$PG_CTL stop -w -D/fwxserver/DB/pg_data"

rm -f $FWCONTROL

# removing launchd plists
rm -f /Library/LaunchAgents/com.filewave.*
rm -f /Library/LaunchDaemons/com.filewave.*
rm -f /System/Library/LaunchAgents/com.filewave.*
rm -f /System/Library/LaunchDaemons/com.filewave.*

# removing old start methods
rm -f /System/Library/StartupItems/FWClient

# removing preferences
rm -rf /Library/Preferences/com.filewave.*
rm -rf /Users/pnr/Library/Preferences/com.filewave.*
rm -rf /Users/pnr/Library/Application\ Support/FileWave

# removing executables
rm -f /usr/local/sbin/fwldap
rm -f /usr/local/sbin/fwxserver
rm -f /usr/local/sbin/fwbooster
rm -f /usr/local/sbin/fwxserverPassword
rm -fr /usr/local/sbin/FileWave.app
rm -fr /Applications/FileWave
rm -fr /Library/Frameworks/FileWave*

# removing receipts
rm -f /var/db/receipts/com.filewave.*

# cleaning up folders used by FileWave
rm -fr /fwxserver
rm -fr /var/FileWave
rm -fr /var/FWBooster
rm -fr /usr/local/filewave
rm -f /usr/local/etc/fwcld.plist
rm -f /usr/local/etc/fwxserver.conf
rm -f /usr/local/etc/fwbooster.conf
rm -f /usr/local/etc/restart_client.sh
rm -f /usr/local/etc/server.lvl
rm -f /usr/local/etc/fwxcodes
rm -rf /usr/local/etc/FileWaveInstall*
sudo killall fwGUI
