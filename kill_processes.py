#!/usr/bin/python


# Application Blacklist configuration - process names in '' , as a list separated by ,
blacklist = ['Console','Activity Monitor']

# Timing Configuration
# Days for the block to be active ; 0 is sunday, 6 is saturday ; default blocks mon-fri
ScheduledBlockWeekdays=[1,2,3,4,5]
# Time for the blocking to begin
ScheduledBlockBeginAt='8:30'
# Time for the blocking to end
ScheduledBlockEndAt='19:04'

# Internal DNS query configuration
InternalNameServers=['10.2.0.1']
InternalHostNameToQuery='demo.filewave.ch'
InternalIPExpected='10.2.4.34'
InternalDNSTimeout=2

# logging configuration
#logfile , full path , enclosed in ' '
logfilename='/var/log/fw-app-bl.log'
#valid loglevels : debug,info,warning,error,critical , enclosed in ' '
loglevel='info'
#log format - look at python logging module for more details
logFormat = '%(asctime)s | %(levelname)s :  %(message)s'


##########################################
# DO NOT CHANGE ANYTHING BELOW THIS LINE #
##########################################

import psutil
import time
import dns.resolver
import dns.exception
import sys
import datetime
import logging

# configure logging
LEVELS = {'debug': logging.DEBUG,
          'info': logging.INFO,
          'warning': logging.WARNING,
          'error': logging.ERROR,
          'critical': logging.CRITICAL}
loglvl = LEVELS.get(loglevel, logging.NOTSET)
logging.basicConfig(filename='/var/log/fw-app-bl.log', level=loglvl,  format=logFormat)

# capture the startup time
shutdown = datetime.datetime.now() + datetime.timedelta(seconds=58)
logging.info("startup: %s  // shutdown at : %s" % (datetime.datetime.now(),shutdown))

# enables the ability to run only on certain weekdays
# and inbetween certain times

# check if we're supposed to block things today, if not exit
weekday = datetime.date.weekday(datetime.datetime.now())
if weekday not in ScheduledBlockWeekdays:
	logging.info('Blocking disabled for this weekday, aborting')
	sys.exit(0)
else:
	logging.info('Blocking enabled for this weekday - checking further ..')

# check if we're inbetween start and stop block time, abort if not
now = datetime.datetime.now().time()
starth,startm = ScheduledBlockBeginAt.split(':')
stoph,stopm = ScheduledBlockEndAt.split(':')

StartBlockingAt = datetime.time(int(starth),int(startm))
StopBlockingAt = datetime.time(int(stoph),int(stopm))
if (StartBlockingAt <= now <= StopBlockingAt ):
	logging.info('blocking schedule active - checking further ..')
else:
	logging.info('blocking schedule inactive, aborting')
	sys.exit(0)

# enables the ability to check presence in a specific network
# by querying the internal DNS for a specific address
# if that DNS Server responds, and responds with the right address
# then we're in the right place to continue running

# set up a dns resolver object using the parameters :
# name server list, and user specified timeout
resolver = dns.resolver.Resolver()
resolver.nameservers = InternalNameServers
resolver.timeout = InternalDNSTimeout
resolver.lifetime = InternalDNSTimeout

# try connecting to the dns server(s) , and retrieve the list possible IP addresses

InternalDNSVerificationSuccess = False
try:
	answer = resolver.query(InternalHostNameToQuery)
	for host in answer:
		if InternalIPExpected in host.to_text():
			logging.info('We have gotten the right answer!')
			InternalDNSVerificationSuccess = True
			break
		else:
			logging.info('Wrong answer received, checking next response')
except dns.exception.Timeout:
	logging.info('DNS Timeout - we probably are not in the right network, shutting down')
	sys.exit(0)
except:
	logging.info('General Error while trying to resolve DNS Address - quitting')
	sys.exit(1)

if InternalDNSVerificationSuccess is not True:
	logging.info('Did not receive correct DNS Address from internal DNS server, exiting ..')
	sys.exit(0)


#start blocking processes

while ( datetime.datetime.now() < shutdown ) :
	procs = psutil.process_iter()
	for proc in procs:
		if proc.name() in blacklist:
			logging.info("killed '%s' for user '%s'" % (proc.name(),proc.username()))
			proc.kill()
	time.sleep(1)
logging.info('exiting')