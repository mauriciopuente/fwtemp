#!/bin/sh
#fwxserver hotbackup script for linux, christiang@filewave.com 23-jan-2013
#specify backup destination as first parameter or as DESTINATION below
#remmeber to use " " quotes if you have spaces/nonascii chars in path
#revision for v.11 , 28-APR-2016 : skip sqlite in case it's not there; backup apache passwords file ; backup media folder ; fixed issues with free space calculation 

log_file="/private/var/log/fw_backup.log"
recommend_help="Wrong arguments. Please check help at fw_hotbackup help."

function log()
{
 echo $1
 echo `date` ' | ' $1 >> $log_file
}

function syntaxError
{
 /bin/echo "+-------------------------------------------------------------------------------------------------------------------"
 /bin/echo "|  Summary:								                                                "
 /bin/echo "|  This script is used to schedule and run FileWave Server backups. It works on both Linux and OS X                 "
 /bin/echo "|  Scheduling is setup using cron jobs (crontab) on both OS X and Linux.                                   	    	" 
 /bin/echo "|  Automated backups run at 12:01 AM either weekly or daily, depending on how you configure it. see examples	"
 /bin/echo "|  Weekly backup will run every Friday night at 12:01 AM								"
 /bin/echo "|  This script, if ran automatically at night, it will restart the FileWave server if postgres is not running	"
 /bin/echo "+-------------------------------------------------------------------------------------------------------------------"
 /bin/echo "|  Examples:												        "
 /bin/echo "|														   	"
 /bin/echo "|  		Automated Backups:										   	" 
 /bin/echo "|                   /path/backup_server.sh  setup daily  /Volumes/backupFolder_path 			   	        "
 /bin/echo "|                   /path/backup_server.sh  setup weekly  /Volumes/backupFolder_path 			   	        "
 /bin/echo "|  	        Manual Backups:											   	"
 /bin/echo "|                   /path/backup_server.sh run  /Volumes/backupFolder_path   manual				   	"
 /bin/echo "|														   	"
 /bin/echo "+-------------------------------------------------------------------------------------------------------------------"
 
}


#check if running as root
if [ ! $(whoami) == "root" ] ; then
        log "Script must be run as root"
        exit 1
fi

if [ "$1" == "setup" ] ; then
  log "setup of backup script "$0
  if [ ! "$#" == "3" ] ; then
    syntaxError
    exit
  fi
  log "Base destination is "$3
  BASEDESTINATION=$3
 
  if [ "$2" == "weekly" ] ; then
    	log "weekly..."
     	cd /usr/local/etc
	/bin/echo "0 1 * * 5  "$0" run "$BASEDESTINATION automated > fwbackup_tab
	/usr/bin/crontab fwbackup_tab
	rm fwbackup_tab
    	exit
  elif  [ "$2" == "daily" ] ; then
     	log "daily...."
	cd /usr/local/etc
        /bin/echo "0 1 * * *  "$0" run "$BASEDESTINATION automated > fwbackup_tab
        /usr/bin/crontab fwbackup_tab
        rm fwbackup_tab
	exit
  else  
    log "parameter not recognised " $2
    syntaxError
    exit
  fi

elif [ "$1" == "run" ] ; then
  if [ ! "$#" == "3" ] ; then
    syntaxError
    exit
  fi
  log "base destination: "$2
  BASEDESTINATION=$2

  # either now (means we running this script manually now) or 'automated' (this script is running from a scheduled task like cronjob)
  # the reason is that: while in automated mode, we don't care if the script restarts the server services if we have to, to be able to run postgres and dump the pg_data.
  MODE=$3

else syntaxError
     exit    
fi

log "=======running backup now ==========="

SIZEFACTOR=2    # 2 means twice as much space as the /fwxserver folder uses must be free to start

#if base destination does not exist , create it
if [ ! -d $BASEDESTINATION ] ; then
	 mkdir -p $BASEDESTINATION
fi

if [ ! -d $BASEDESTINATION ] ; then
	log "Could not create dir "$BASEDESTINATION
 	exit 1
fi

#define the temporary location and archive name here
TEMPDIR=$BASEDESTINATION/tmp/fwxserver-Config-DB-$(date +%b-%d-%y--%H-%M)
#make sure tempdir is created:
log "Making temp path: "$TEMPDIR
mkdir -p $TEMPDIR
if [ ! -d $TEMPDIR ]; then
 log "Could not create dir "$TEMPDIR
 exit 1
fi

DESTINATION=$BASEDESTINATION/fw-backups
log "Making destination path: "$DESTINATION
mkdir -p  $DESTINATION
if [ ! -d $DESTINATION ]; then
 echo "Could not create dir "$DESTINATION
 exit 1
fi


#define a logfile for the backups, if it's not defined it will write to stdout
#LOGFILE=$DESTINATION/fw-backup-$(date +%b-%d-%y--%H-%M).log

####################DO NOT MODIFY BELOW THIS LINE
#transform into absolute path just in case parameter was relative
cd $DESTINATION
DESTINATION=$(pwd)

#patch for version 11 ; skip sqlite backups in case they're not there
if [ -f '/fwxserver/DB/admin.sqlite' ] ; then
    #check if sqlite3 binary is available
    if [ $(which sqlite3 2>&1 | grep "no sqlite3 in" | wc -l) -gt 0 ] ; then
            log "No sqlite3 binary found in Path. Please install sqlite3 and try again"
            exit 1
    fi
    log "sqlite3 binary available: Ok"
fi

#check if rsync binary is available
if [ $(which rsync 2>&1 | grep "no rsync in" | wc -l) -gt 0 ] ; then
	log "No rsync binary found in Path. Please install rsync and try again"
	exit 1
fi
log "rsync binary available: Ok"

#check if there's enough space left for the database backup
DESTFREE=$(df -Pk $DESTINATION | tail -n 1 | awk {'print $4'})
TEMPFREE=$(df -Pk $(dirname $TEMPDIR) | tail -n 1 | awk {'print $4'})
BACKUPSIZE=$(du -sk /fwxserver/DB | awk {'print $1'})
#calculate minimum free size on /tmp and destination
((BACKUPSIZE=$BACKUPSIZE*$SIZEFACTOR))
#check destination FS space availability
if [ $DESTFREE -lt $BACKUPSIZE ] ; then
	log "Not Enough Space for DB Backup at Destination"
	exit 1
fi
#check temp FS space availability
if [ $TEMPFREE -lt $BACKUPSIZE ] ; then
	log "Not enough Space on /tmp for DB Backup"
	exit 1
fi

log "Free disk space to run backup: Ok"

#start working
log  "Creating temporary backup directory at $TEMPDIR"
/bin/mkdir -p $TEMPDIR/DB
/bin/mkdir -p $TEMPDIR/certs
/bin/chmod -R 777 $TEMPDIR


if [ ! -f "/tmp/.s.PGSQL.9432.lock" ]; then
   log "connection to postgres database is not possible. Is postgres server running and accepting connections on Unix domain socket '/tmp/.s.PGSQL.9432'"
   # check the MODE to decide what to do:
   if [ $MODE == "manual" ]; then
     log "Please make sure your server is running properly. restarting the server with 'sudo fwcontrol server restart' might fix the issue."
     exit
   fi
   # we are then in the automated mode which most likely will run overnight like we have in the crontab setup above.
   log "restarting the server now and trying again..."
   /sbin/fwcontrol server restart
   sleep 3
   if [ ! -f "/tmp/.s.PGSQL.9432.lock" ]; then 
     log "there is still a problem with postgres not running. Please contact technical support."
     log "exiting."
     exit
   fi
fi

log "dumping MDM postgres database to :"$TEMPDIR"/DB/mdm-dump.sql"
cd /
/usr/local/filewave/postgresql/bin/pg_dump -U postgres -d mdm -f $TEMPDIR/DB/mdm-dump.sql


#patch for version 11 ; skip sqlite backups in case they're not there
if [ -f '/fwxserver/DB/admin.sqlite' ] ; then
    #copy all commited databases to temporary backup destination
    log "Backing up commited&ldap databases.."
    cp /fwxserver/DB/committed* $TEMPDIR/DB
    log "Backing up admin, ldap and server database.."
    echo '.dump' | sqlite3 /fwxserver/DB/admin.sqlite | sqlite3 $TEMPDIR/DB/admin.sqlite
    echo '.dump' | sqlite3 /fwxserver/DB/server.sqlite | sqlite3 $TEMPDIR/DB/server.sqlite
    echo '.dump' | sqlite3 /fwxserver/DB/ldap.sqlite | sqlite3 $TEMPDIR/DB/ldap.sqlite
fi

log "Backing up Server Certs.."
cp /usr/local/filewave/certs/* $TEMPDIR/certs

log "backing up httpd.conf, http_custom.conf and mdm_auth.conf"
cp /usr/local/filewave/apache/conf/httpd.conf $TEMPDIR/
cp /usr/local/filewave/apache/conf/httpd_custom.conf $TEMPDIR/
cp /usr/local/filewave/apache/conf/mdm_auth.conf $TEMPDIR/

log "backing up apache htpasswd file"
cp /usr/local/filewave/apache/passwd/passwords $TEMPDIR/


#bundle up the database backup
log "zipping...."
cd $(dirname $TEMPDIR)
tar -zcvf $(basename $TEMPDIR).tar.gz $(basename $TEMPDIR)
mv $(basename $TEMPDIR).tar.gz $DESTINATION

#rsync the data folder
log "Starting rsync of Data Folder to $DESTINATION/Data Folder...."
rsync -aL /fwxserver/Data\ Folder/ $DESTINATION/Data\ Folder
log "rsync data folder done"

#rsync the ipa folder
log "Starting rsync of .ipa Folder to $DESTINATION/ipa.."
rsync -aL /usr/local/filewave/ipa/ $DESTINATION/ipa
echo "rsync ipa done"

#rsync the media folder
log "Starting rsync of .ipa Folder to $DESTINATION/ipa.."
rsync -aL /usr/local/filewave/media/ $DESTINATION/ipa
echo "rsync ipa done"


#done 
log "Removing temporary Backup Directory at $TEMPDIR"
rm -rf $TEMPDIR
log "FileWave Server backup completed at $(date +%H-%M)"




