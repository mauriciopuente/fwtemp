
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



with open('/tmp/ipads.csv', 'rt') as f:
    reader = csv.reader(f)
    my_list = list(reader)

print (my_list)

udids = [j[0] for j in my_list]

print (udids)

# select name from admin.user_clone_group where type =24 and id = (select a.id from admin.user_clone_group a, admin.mobile_client_info b where b.udid = '%s' and b.ucg_id = a.id

statement = '''update admin.user_clone_group set comment = 'TO BE DELETED' where type =24 and id = (select a.id from admin.user_clone_group a, admin.mobile_client_info b where b.udid = '%s' and b.ucg_id = a.id)'''


for i in udids:
    print ("To Be Deleted Device with uuid : ","\t-->\t",str(i))
    mark.execute(statement %(i))


# Commit the change
connection.commit()

# Close the db connection
connection.close()