#!/usr/bin/python

#admin.sqlite:
#-------------
#update user_clone_group set comment = "My iPad" where name = "Mauricio's iPad";

import sqlite3
import sys,os
import csv

#Reads Filewave client names values from a CSV file, and writes the Asset tag to comments of iOS devices.
#
#CSV Format is:
#FileWave Client Name,Asset Tag
#Comma delimited and Case sensitive
#CSV Location and name is /usr/local/etc/naming.csv
#
#Make sure the CSV file doesn't have empty lines or extra lines at the end of the file.

with open('/usr/local/etc/naming.csv', 'rb') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print "\n\nList of Devices and Asset Tags\n\n"
print my_list
print ""

try:
    # Opens admin.sqlite
    db = sqlite3.connect('/fwxserver/DB/admin.sqlite')
except:
    print "I am unable to connect to the database"

statement = '''update user_clone_group set comment = "%s" where name = "%s"'''   

# Get a cursor object
cursor = db.cursor()

# Runs across the list and modifies query
for i in my_list:
    print i[0],"\t -- Asset Tag --> \t",i[1]
    print statement % (i[1],i[0])
    print "" 
    cursor.execute(statement % (i[1],i[0]))

# Commit the change
db.commit()
# Close the db connection
db.close()

