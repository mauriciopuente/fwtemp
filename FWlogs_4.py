__author__ = 'Mauricio Puente Cadena'

import os, sys
import platform
import shutil
import getpass
import datetime
import tempfile
import tarfile
import re
import zipfile

def zipdir(path, ziph):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file))


if os.name == 'posix' and (platform.system() == 'Darwin' or platform.system() == 'Linux' or  platform.system() == 'Linux2'):
    # Path to the logs
    log_list = ['/private/var/log/fwxserver.log','/private/var/log/fwxother.log','/private/var/log/fwxadmin.log','/private/var/log/fwldap.log','/usr/local/filewave/log/filewave_django.log','/usr/local/filewave/log/request_errors.log','/usr/local/filewave/apache/logs/access_log','/usr/local/filewave/apache/logs/error_log','/usr/local/filewave/log/py_scheduler.log']


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
    
    print "\nZipping files ...\n"
    
    zipf = zipfile.ZipFile('Filewave_logs.zip', 'w')
    zipdir(path, zipf)
    zipf.close()
    
    print "\nZipping Done! ...\n"
    shutil.copy2('Filewave_logs.zip', "/Users/"+str(current_user)+"/Desktop")
    print "\nFiles copied to /Users/"+str(current_user)+"/Desktop/Filewave_logs.zip Succesfully!\n"
    os.remove('Filewave_logs.zip')


else:
    print "I'm a Windows Server...\n\n"

    log_list = [r'C:\ProgramData\FileWave\FWServer\fwxserver.log',r'C:\ProgramData\FileWave\FWServer\fwxadmin.log',r'C:\ProgramData\FileWave\FWServer\fwldap.log',r'C:\ProgramData\FileWave\FWServer\fwxother.log',r'C:\Program Files (x86)\FileWave\apache\logs\error.log',r'C:\Program Files (x86)\FileWave\apache\logs\access_log',r'C:\ProgramData\FileWave\FWServer\log\filewave_django.log',r'C:\ProgramData\FileWave\FWServer\log\request_errors.log',r'C:\ProgramData\FileWave\FWServer\log\py_scheduler.log']


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
    
    print "\nZipping files ...\n"
    
    zipf = zipfile.ZipFile('Filewave_logs.zip', 'w')
    zipdir(logs_path, zipf)
    zipf.close()
    
    print "\nZipping Done! ...\n"


