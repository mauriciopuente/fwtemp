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
    log_list = ['/var/log/fwcld.log','/var/log/messages','/imaging/logs/django_requests.log','/imaging/logs/filewave_imaging_server-error.log','/imaging/logs/netboot_access.log','/imaging/logs/filewave_imaging_server-access.log','/imaging/logs/filewave_imaging_server-request.log','/imaging/logs/netboot_error.log']


    print "Current user --> ",getpass.getuser()
    current_user = getpass.getuser()

    # Path to be created
    path = "/Users/"+str(current_user)+"/Desktop/My_Imaging_logs"

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
    print "This is a Windows machine, not an IVS ... \n\n"


