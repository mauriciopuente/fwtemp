import sqlite3
import sys,os
import shutil


my_list = ["f1f477b317dcde6eef33e08c491c5c14ef8302cc","104bb24f99e00495a33d2ed17cbcfef7410d3f37"]

#Backup the admin.sqlite DataBase
path = "/fwtemp"
adminsqlite = "/fwxserver/DB/admin.sqlite"

def backup_db(db_path):
    if not os.path.exists(db_path):
        os.makedirs( db_path, 0755 );
        print "Path "+db_path+" was created\n"
    if os.path.exists(adminsqlite):
        shutil.copy2(adminsqlite, db_path)
        print adminsqlite,"\t-\tCopied correctly to",db_path
    else:
        print "Path ", adminsqlite, "Does not exist!\n"


try:
    # Opens admin.sqlite
    db = sqlite3.connect('/fwxserver/DB/admin.sqlite')
except:
    print "I am unable to connect to the database"

statement = '''update user_clone_group set name = "TO BE DELETED" where type = 24 and id = (select a.id from user_clone_group a, mobile_client_info b where b.udid = "%s" and b.ucgID = a.id)'''

#statement = '''delete from user_clone_group where id = (select a.id from user_clone_group a, mobile_client_info b where b.udid = "%s" and b.ucgID = a.id)'''

# Get a cursor object
cursor = db.cursor()


print "\n\n*************************************************************************************************\n"
print "This script will delete the iPads in Filewave Admin's Clients view \n"
print "Remember to restart the FWAdmin and then update model to see the changes \n"
print "*************************************************************************************************\n\n"

print "Backing up admin.sqlite DataBase (Backup will be saved in /fwtemp/admin.sqlite) ...\n"
backup_db(path)

print "\n\nDeleting iPads ...\n\n"
# Runs across the list and modifies query
for i in my_list:
	print i,"\t\t <-- Renaming --> \t"
	print ""
        cursor.execute(statement % i)

# Commit the change
db.commit()

# Close the db connection
db.close()