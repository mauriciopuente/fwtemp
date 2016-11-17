#!/bin/sh
export udids=$1
scr='removeapp.py'

/bin/cat <<EOM >$scr
from ios.apn import send_apn_to_devices
from ios.command_queue import CommandQueue
from ios.models import MDMUser
from ios.ios_commands import create_command_from_request_type
from filewave.fw_util.helpers import get_locale_aware_datetime_now, LockingStrategy
import os
from apple.activationlock.activationlock import ActivationLock, ActivationLockRemovalError,\
    ActivationLockByPassCodeNotRetrieved

filepath = os.environ.get('udids')
print filepath
if not filepath:
    print "Please set file path to 'udids' env variable"
    exit(-1)

udids = set()

# read file and get unique udids
with open(filepath, "r") as f:
    udids = {udid.strip() for udid in f}

for user in MDMUser.get_users_and_command_queue(device_ids=udids,
                locking=LockingStrategy.FOR_UPDATE_OF_COMMAND_QUEUE,
                exclude_users=True
            ):
    udid = user.mdm_client.udid
    print "Add Remove app Command device with udid %s" % udid
    cq = CommandQueue(user)
    cq.create_remove_application_command(bundle_identifier="com.filament.dihar2",)
    cq.sync_to_db()


if udids:
    print "Send apns"
    send_apn_to_devices(udids=udids)
EOM

echo "execfile('removeapp.py')" | /usr/local/filewave/python/bin/python /usr/local/filewave/django/manage.pyc shell
