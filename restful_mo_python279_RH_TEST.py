#!/usr/bin/python
#this is a CSV exporter for a group of queries listing all results of the queries contained within that group
#this enables easy adding of queries through the UI
#for each query, a separate file is created - using the template OUTPUT_FILENAME-QUERYNAME.csv

#christiang@filewave.com , 21-SEP-2015

# mauriciop@filewave.com , FEB-04-2016
# FEB-04-2016 -- Bool data type is accepted, CSV file comma separated, double quotes as Text delimiter (")
# FEB-08-2016 -- Set to ignore SSL verification introduced on Python 2.7.9



SHARED_SECRET = "e2IxNmMwZjQzLWZiN2UtNGJhMy1hZTM1LThkZDhlNWEwMDgxOX0="
SERVER_NAME = "10.1.3.204"
SERVER_PORT = "20443"
GROUP_ID = "2"
OUTPUT_FILENAME = "Mauricio-Restful-Export.csv"

#DO NOT CHANGE ANYTHING BELOW THIS LINE

#libraries
import urllib2
import json
import sys
import codecs
import ssl

try:
    _create_unverified_https_context = ssl._create_unverified_context
except AttributeError:
    # Legacy Python that doesn't verify HTTPS certificates by default
    pass
else:
    # Handle target environment that doesn't support HTTPS verification
    ssl._create_default_https_context = _create_unverified_https_context


def run_query(QUERY_ID,OUTPUT_FILENAME,SERVER_NAME,SERVER_PORT,SHARED_SECRET):
	#get the query definition and name for the specified ID
	request = urllib2.Request("https://%s:%s/inv/api/v1/query/%s" % (SERVER_NAME,SERVER_PORT,QUERY_ID))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	result = urllib2.urlopen(request)
	querydefinition = json.load(result)
	
	#split the query name at " - " - leistungsart before, and beschreibung after
	fullqueryname = querydefinition['name']
	outputfilename = OUTPUT_FILENAME.replace('.csv', '-%s.csv' % fullqueryname)	

	#create an output file for this query
	try :
                f = open(outputfilename,'w')
        except IOError as e:
                print "I/O error({0}): {1}".format(e.errno, e.strerror)
                print "Error writing to %s, check file permissions" % OUTPUT_FILENAME
                sys.exit(1)
	
	#run the modified query
	request = urllib2.Request("https://%s:%s/inv/api/v1/query_result/%s" % (SERVER_NAME,SERVER_PORT,QUERY_ID))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	request.add_header("Content-Type", "application/json")
	result = urllib2.urlopen(request) 
	data = json.load(result)
	clientvalues = data['values']
	for client in clientvalues :
		#if there are queries that return applications as well, filter those out - we only want lines that contain clients ! 
		if client[0] > 0 :
			for datapoint in client :
				if datapoint is not None : 
					if type(datapoint) is int or type(datapoint) is bool: 
						f.write('"%s",' % (datapoint))
					else:
						f.write('"%s",' % (datapoint.encode('UTF-8')))
				else :
					f.write(",")
			f.write("\n")

	f.close()


def get_querylist(SERVER_NAME,SERVER_PORT,SHARED_SECRET,groupid):
	#get the list of all queries in the group we want to look at (specified by groupid)
	request = urllib2.Request("https://%s:%s/inv/api/v1/query/" % (SERVER_NAME,SERVER_PORT))
	request.add_header("Authorization", "%s" % SHARED_SECRET)
	#context = ssl.create_unverified_context()
    	#context = ssl.create_default_context(cafile="/fwtemp/ssl/mo.in.filewave.us.crt")
	#result = urllib2.urlopen(request, context=context)
    
    	#ctx = ssl.create_default_context()
    	#ctx.check_hostname = False
    	#ctx.verify_mode = ssl.CERT_NONE

    	result = urllib2.urlopen(request)
	data = json.load(result)
	querylist = []
	for query in data :
		if query['group'] == groupid:
			querylist.append(query['id'])
	#print querylist
	return(querylist)

if __name__=='__main__':
		
	
	#get the list of queries in groupid , and run all of them
	#(( with normalized output (overriding the "fields" part of the query) ))
	querylist = get_querylist(SERVER_NAME, SERVER_PORT, SHARED_SECRET, int(GROUP_ID))
	
	for queryid in querylist :
		run_query(queryid,OUTPUT_FILENAME,SERVER_NAME,SERVER_PORT,SHARED_SECRET)
	
	sys.exit(0)
