__author__ = 'Mauricio'

import os, sys
import platform
import shutil
import getpass
import datetime
import tempfile
import tarfile
import re

def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))


if os.name == 'posix' and (platform.system() == 'Darwin' or platform.system() == 'Linux' or  platform.system() == 'Linux2'):
    # Path to the logs
    log_list = ['/private/var/log/fwxserver.log','/usr/local/filewave/log/filewave_django.log','/usr/local/filewave/log/request_errors.log','/usr/local/filewave/apache/logs/access_log','/usr/local/filewave/apache/logs/error_log','/usr/local/filewave/log/py_scheduler.log']


    print "Current user --> ",getpass.getuser()
    current_user = getpass.getuser()

    # Path to be created
    path = "/Users/"+str(current_user)+"/Desktop/MyFWlogs"

    if not os.path.exists(path):
        os.makedirs( path, 0755 );
        print "Path "+path+" is created\n"


        for i in log_list:
            if os.path.exists(i):
                shutil.copy2(i, path)
                print i,"\t-\tCopied"
            else:
                print "Path ", i, "Does not exist!\n"

        # Compress the logs:
        #make_tarfile('Prueba_MPC',logs_path)

    else:
        a=datetime.datetime.now()
        path=path+"_"+str(a.hour)+"_"+str(a.minute)+"_"+str(a.second)+"_"+str(a.year)
        os.makedirs( path, 0755 );
        print "Path "+path+" is created\n"


        for i in log_list:
            if os.path.exists(i):
                shutil.copy2(i, path)
                print i,"\t-\tCopied"
            else:
                print "Path ", i, "Does not exist!\n"

    print "\nFiles copied to "+path+" Succesfully!\n"


else:
    print "I'm a Windows Server...\n\n"

    log_list = [r'C:\ProgramData\FileWave\FWServer\fwxserver.log',r'C:\ProgramData\FileWave\FWServer\fwxadmin.log',r'C:\ProgramData\FileWave\FWServer\fwxother.log',r'C:\Program Files (x86)\FileWave\apache\logs\error.log',r'C:\Program Files (x86)\FileWave\apache\logs\access_log',r'C:\ProgramData\FileWave\FWServer\log\filewave_django.log',r'C:\ProgramData\FileWave\FWServer\log\request_errors.log',r'C:\ProgramData\FileWave\FWServer\log\py_scheduler.log']


    logs_path=r'C:\MyFWlogs'
    if not os.path.exists(logs_path):
        os.makedirs(logs_path)
        print "Path "+logs_path+" was created\n"

        for i in log_list:
            if os.path.exists(i):
                shutil.copy2(i, logs_path)
                print i,"\t-\tCopied"
            else:
                print "Path ", i, "Does not exist!\n"


    else:
        a=datetime.datetime.now()
        logs_path=logs_path+"_"+str(a.hour)+"_"+str(a.minute)+"_"+str(a.second)+"_"+str(a.year)
        os.makedirs(logs_path)
        print "Path "+logs_path+" was created\n"

        for i in log_list:
            if os.path.exists(i):
                shutil.copy2(i, logs_path)
                print i,"\t-\tCopied"
            else:
                print "Path ", i, "Does not exist!\n"


    print "\nFiles copied to "+logs_path+" Succesfully!\n"

#    Falta, compress created directory!!!

