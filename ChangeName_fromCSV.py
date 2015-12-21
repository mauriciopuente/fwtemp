#!/usr/bin/python

# Author: Mauricio Puente Cadena.

#Reads Filewave client names values from a CSV file, and writes them to the Clients view for iOS devices.
#
#CSV Format is:
#-------------
#   uuid,filewave_client_name,serial_number
#Comma delimited and Case sensitive
#
#The CSV file is generated from this script as well:
#-----------------------------------------------------
#   \Copy (select device_id, filewave_client_name, serial_number from generic_genericclient where device_product_name like '%iPad%') To '/usr/local/etc/naming.csv' With CSV;
#
#Change the filewave_client_name field for the desired name
#
#CSV Location and name is /usr/local/etc/naming.csv
#
#Make sure the CSV file doesn't have empty lines or extra lines at the end of the file.

import sqlite3
import sys,os
import shutil
import csv

import psycopg2
from itertools import izip


#Creates the CSV file:
#--------------------

archivo = "/usr/local/etc/naming.csv"

f = open(archivo, "a")


def chunker(iterable, chunksize):
    return zip(*[iter(iterable)]*chunksize)


try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"

mark = connection.cursor()


k = 0
statement = """
            select device_id, serial_number from generic_genericclient where device_product_name like '%iPad%'
            """
mark.execute(statement)
record = mark.fetchall()

pos = 0
for i in record:
        temp=list(chunker(i,2))        # [1,2,3,4] --> [(1,2),(3,4)]
        for p in temp:
                f.write(p[0]+","+p[1])
                f.write("\n")
f.close()



#------------------------


# Creates a new list with only the first element of each tuple as long as the tuple's first element is not Null
def clean_list(x):
    templist = []
    for i in x:
        if i[0] != None:
            templist.append(str(i[0].encode("utf-8")))
    return templist
    
# Creates a list with the elements from list of devices that are not present in the Database List    
def compare_lists(x,y):
    comp_list = []
    for i in x:
        if i not in y:
            comp_list.append(i)
    return comp_list
    

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
        

with open('/usr/local/etc/naming.csv', 'rb') as f:
    reader = csv.reader(f)
    my_list = list(reader)

#print "\n\nList of Devices and Asset Tags\n\n"
#print my_list
#print ""

try:
    # Opens admin.sqlite
    db = sqlite3.connect('/fwxserver/DB/admin.sqlite')
except:
    print "I am unable to connect to the database"

statement = '''update user_clone_group set name = "%s" where name = "Mr.Avery" and id = (select a.id from user_clone_group a, mobile_client_info b where b.udid = "%s" and b.ucgID = a.id)'''
statement2 = '''select name, comment from user_clone_group''' 

# Get a cursor object
cursor = db.cursor()
cursor2 = db.cursor()

cursor2.execute(statement2)

record = cursor2.fetchall()
#print "\n\nFrom DataBase\n\n"
#print record

#print "\n\nLista limpia\n\n"
#print clean_list(record),"\n\n"
dblist = clean_list(record)

#print "\n\nOnly Device Names\n\n"
#print clean_list(my_list),"\n\n"
csv_list = clean_list(my_list)

#for i in record:
#    print i

print "\n\n*************************************************************************************************\n"
print "This script will change Names for the iPads in Filewave Admin's Clients view \n"
print "Remember to have the naming.csv file saved in /usr/local/etc/naming.csv \n"
print "*************************************************************************************************\n\n"
print "Backing up admin.sqlite DataBase (Backup will be saved in /fwtemp/admin.sqlite) ...\n"
backup_db(path)
print "\n\nChanging Names ...\n\n"
# Runs across the list and modifies query
for i in my_list:
	print i[1],"\t\t <-- New Name for this uuid --> \t",i[0]
	print "" 
    	cursor.execute(statement % (i[1],i[0]))

# Commit the change
db.commit()

# Close the db connection
db.close()


