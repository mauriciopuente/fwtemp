#!/usr/bin/env python
# encoding: utf-8

import datetime
import psycopg2
import sys

# First part
from generic.models import *
from api.mdm_command import MDMCommandFWModelView

# Second part
from inventory.models.query import Query
from inventory.query import QueryExecutor


# 1st Part: ok, let's perform a cleanup first (maybe try out each line individually):

MDMCommandFWModelView.clean_unused_model_instances(Application)
MDMCommandFWModelView.clean_unused_model_instances(Font)
MDMCommandFWModelView.clean_unused_model_instances(Fileset)

now = datetime.datetime.now()

year = now.year
year = str(year)

month = now.month
month = str(month)

day = now.day
day = str(day)

hora = now.hour
hora = str(hora)

minuto = now.minute
minuto = str(minuto)

segundo = now.second
segundo = str(segundo)

archivo = "Inventory_Query_"+year+"_"+month+"_"+day+"__"+hora+"_"+minuto+"_"+segundo+"."+"txt"

f = open(archivo, "a")

 
# 2nd Part

## ===========================================================================



try:
    connection = psycopg2.connect("dbname=mdm user=django")
except:
    print "I am unable to connect to the database"

mark = connection.cursor()


k = 0
statement = """
            select id
            from inventory_query where favorite = TRUE
            """
mark.execute(statement)
record = mark.fetchall()
for i in record:
    for j in i:
        j = int(j)
        print "Running Query number ",str(j)
        query = get_object_or_404(Query, pk=j)
        executor = QueryExecutor(query)
        queryset = executor.queryset
        queryset.count()
        f.write(str(j) + "\n")
f.close()



## ========================================================================================





