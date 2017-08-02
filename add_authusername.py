#!/usr/bin/python

# Author: Mauricio Puente Cadena.
# Works on FileWave v12 Python 3
#Reads Filewave client Serial Numbers from a CSV file, and writes the Auth Username to the DB.
#
#CSV Format is:
#SerialNumber,Auth Username
#Comma delimited and Case sensitive
#CSV Location and name is /usr/local/etc/authusernames.csv
#
#Make sure the CSV file doesn't have empty lines or extra lines at the end of the file.

# ====================================================================================


import csv
import psycopg2


#Connecting to the DB
try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print ("I am unable to connect to the database")
    print ("This script must be run on the server where the filewave server is installed")
    print ("Please verify that 'postmaster' processes are running and try again")

mark = connection.cursor()


with open('/usr/local/etc/authusernames.csv', 'rt') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print ("\nThis is the list :\n",my_list)


print ("\n\n*************************************************************************************************\n")
print ("This script will add the Authusernames to the Data Base \n")
print ("Remember to have the authusernames.csv file saved in /usr/local/etc/authusernames.csv \n")
print ("*************************************************************************************************\n\n")


statement = """update generic_genericclient set auth_username = '%s' where serial_number = '%s'"""


for i,j in my_list:
    print ("Adding Auth Username to device with Serial Number : ",i,"\t Auth UserName will be -->\t",j)
    mark.execute(statement %(j,i))

# Commit the change
connection.commit()

# Close the db connection
connection.close()

