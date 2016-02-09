#!/usr/bin/python
#this is a CSV exporter for a group of queries listing all devices that contain a certain software
#returns device_name,query_name for all queries inside of GROUP_ID
#this enables easy adding of queries through the UI

#for Ringier : Query Name = "Leistungsart - Beschreibung"  for example : "PHOTOSHP1 - Adobe Photoshop CS5"
#GROUP_ID is 38

#christiang@filewave.com , 19-FEB-2014

SHARED_SECRET = "ezgwNzRlY2UzLWQxNGMtNGM3MC1iMTZmLTg0ODA5M2Q5NjhmZX0="
SERVER_NAME = "mo.in.filewave.us"
SERVER_PORT = "20443"
GROUP_ID = "2"
OUTPUT_FILENAME = "Export.csv"

#DO NOT CHANGE ANYTHING BELOW THIS LINE

#libraries
import urllib2
import json
import sys
import codecs

def run_query(QUERY_ID,f,SERVER_NAME,SERVER_PORT,SHARED_SECRET):
	#get the query definition and name for the specified ID
	request = urllib2.Request("https://%s:%s/inv/api/v1/query/%s" % (SERVER_NAME,SERVER_PORT,QUERY_ID))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	result = urllib2.urlopen(request)
	querydefinition = json.load(result)
	
	#split the query name at " - " - leistungsart before, and beschreibung after
	fullqueryname = querydefinition['name']
	leistungsart,beschreibung=str(fullqueryname).partition(" - ")[2],str(fullqueryname).partition(" - ")[0]
	
	#replace the fields part of the definition with a predefined format:
	fields = [{"column": "device_name", "component": "DesktopClient"}]
	querydefinition['fields'] = fields
	
	#run the modified query
	request = urllib2.Request("https://%s:%s/inv/api/v1/query_result/" % (SERVER_NAME,SERVER_PORT))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	request.add_header("Content-Type", "application/json")
	result = urllib2.urlopen(request,json.dumps(querydefinition)) 
	data = json.load(result)
	clientvalues = data['values']
	for client in clientvalues :
		#append leistungsart from the name of the query as the last column
		client.append(leistungsart)
		#if there are queries that return applications as well, filter those out - we only want lines that contain clients ! 
		if client[0] > 0 :
			for datapoint in client :
				if datapoint is not None : 
					f.write("%s," % (datapoint.encode('UTF-8')))
				else :
					f.write(",")
			f.write("\n")


def get_querylist(SERVER_NAME,SERVER_PORT,SHARED_SECRET,groupid):
	#get the list of all queries in the group we want to look at (specified by groupid)
	request = urllib2.Request("https://%s:%s/inv/api/v1/query/" % (SERVER_NAME,SERVER_PORT))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	result = urllib2.urlopen(request)
	data = json.load(result)
	querylist = []
	for query in data :
		if query['group'] == groupid:
			querylist.append(query['id'])
	#print querylist
	return(querylist)

if __name__=='__main__':
		
	#create an output file, error if we can't open or write to it
	try :
		f = open(OUTPUT_FILENAME,'w')
	except IOError as e:
		print "I/O error({0}): {1}".format(e.errno, e.strerror)
		print "Error writing to %s, check file permissions" % OUTPUT_FILENAME
		sys.exit(1)
	f.write("device name,Leistungsart\n")
	
	#get the list of queries in groupid , and run all of them
	#(( with normalized output (overriding the "fields" part of the query) ))
	querylist = get_querylist(SERVER_NAME, SERVER_PORT, SHARED_SECRET, GROUP_ID)
	
	for queryid in querylist :
		run_query(queryid,f,SERVER_NAME,SERVER_PORT,SHARED_SECRET)
	
	#close the file, and exit	
	f.close()
	sys.exit(0)
