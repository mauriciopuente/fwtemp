from ios.apn import send_apn_to_devices
from ios.command_queue import CommandQueue
from ios.models import MDMUser
from ios.ios_commands import create_command_from_request_type
from filewave.fw_util.helpers import get_locale_aware_datetime_now, LockingStrategy
import os
import csv
from apple.activationlock.activationlock import ActivationLock, ActivationLockRemovalError,\
    ActivationLockByPassCodeNotRetrieved

import psycopg2


#Connecting to the DB
try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"
    print "This script must be run on the server where the filewave server is installed"
    print "Please verify that 'postmaster' processes are running and try again"

mark = connection.cursor()



with open('C:\Temp\udids.csv', 'rb') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print my_list

udids = [j[0] for j in my_list]

# select name from admin.user_clone_group where type =24 and id = (select a.id from admin.user_clone_group a, admin.mobile_client_info b where b.udid = '%s' and b.ucg_id = a.id

statement = '''update admin.user_clone_group set name = '%s' where type =24 and id = (select a.id from admin.user_clone_group a, admin.mobile_client_info b where b.udid = '%s' and b.ucg_id = a.id)'''


for user in MDMUser.get_users_and_command_queue(device_ids=udids,
                locking=LockingStrategy.FOR_UPDATE_OF_COMMAND_QUEUE,
                exclude_users=True
            ):
    udid = user.mdm_client.udid
    for i,j in my_list:
        if udid == i:
            print "Renaming device with uuid : ",udid,"\t-->\t",j
            mark.execute(statement %(j,i))

            print "Add Set Name Command device with udid %s" % udid
            cq = CommandQueue(user)
            cq.create_set_device_name_command(new_name=j,)
            cq.sync_to_db()

# Commit the change
connection.commit()

# Close the db connection
connection.close()