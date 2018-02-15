import os, sys
import platform
import subprocess
import datetime
import requests
import tarfile
import json
import time


unix_mdm_dump = '/tmp/'
win_mdm_dump = 'C:\\'
unix_pgdump = '/usr/local/filewave/postgresql/bin/pg_dump'
now = datetime.datetime.now()


# Function to compress files.
def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))


# Gets the MDM dump.
def dump_db(pgdump_location,mdm_dump_location):
    try:
        p = subprocess.Popen([pgdump_location,"-U","django","--encoding=UTF8","-c","-f",mdm_dump_location,"-N","committed_*","mdm"],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out,err = p.communicate()
    except Exception:
        print("There was an error dumping the Data Base :\n",err)
        print("Return Code :\n",p.returncode)


# Check if the script is on a FileWave Server.
def is_this_fw_server(fw_folder_location):
    return os.path.exists(fw_folder_location)



# Get the FW license code.
def create_licstr(lic_file):
    #retreive the uuid we use for identification
    try :
        licfile = open(lic_file,'r')
        licjson = json.loads(licfile.read())
        licid = licjson['uuid']
        licfile.close()
    except :
        ### TBD : Create 32bit eval id string containing servername ####
        licid = "0110010101110110011000010000eval"
        #print "no unique identification file found .. generating id for identification"
    return(licid)


# Check what OS the server is running on
if os.name == 'posix' and (platform.system() == 'Darwin' or platform.system() == 'Linux' or  platform.system() == 'Linux2'):
    #print("This is a Unix OS : ")
    mdm_dump = unix_mdm_dump
    pgdump = unix_pgdump
    licensefile = '/usr/local/etc/fwxcodes'
    is_postgres_running = 'fwxserver/DB/pg_data' in subprocess.check_output(['ps','-ax']).decode("utf-8")
    startpostgres = lambda : subprocess.call(['fwcontrol','postgres','start'])
    fwxserver_loc = '/usr/local/sbin/fwxserver'
    osname = platform.platform(aliased=True)
    if 'Darwin' in osname:
        osinfo = subprocess.check_output(['defaults','read','/System/Library/CoreServices/SystemVersion.plist','ProductVersion']).decode("utf-8")
        osinfo = osinfo.replace('\n','')
        osinfo = "MacOS"+osinfo
    else:
        osinfo = osname
else:
    #print("This is a Windows OS :")
    try:
        filewave_dir = os.path.join(os.environ['PROGRAMFILES(x86)'],'FileWave')
    except KeyError:
        filewave_dir = os.path.join(os.environ['PROGRAMFILES'],'FileWave')

    mdm_dump = win_mdm_dump
    pgdump = os.path.join(filewave_dir,'postgresql\\bin\\pg_dump.exe')
    licensefile = os.path.join(os.environ['PROGRAMDATA'], 'FileWave\\FWServer\\fwxcodes')
    is_postgres_running = 'postgres.exe' in subprocess.check_output(['tasklist.exe','/v']).decode("utf-8")
    startpostgres = lambda : subprocess.call(['sc','start','FileWave MDM PostgreSQL'])
    osname = platform.platform(aliased=True)
    osinfo = osname
    fwxserver_loc = os.path.join(filewave_dir,'bin\\fwxserver.exe')


######### MAIN ###########

print('Operating System:', platform.platform(aliased=True))
print('Short Name  :', platform.platform(terse=True))

if is_this_fw_server(pgdump):
    try:
        if not is_postgres_running:
            startpostgres()
            print("Starting Postgres, this may take a few seconds ...")
            time.sleep(10)
            if 'Windows' not in osname:
                is_postgres_running = 'fwxserver/DB/pg_data' in subprocess.check_output(['ps','-ax']).decode("utf-8")
            else:
                is_postgres_running = 'postgres.exe' in subprocess.check_output(['tasklist.exe','/v']).decode("utf-8")
            if not is_postgres_running:
                print("We could not start the Postgres process, please start it manually and run this script again.")
                sys.exit(1)
        fwxversion = subprocess.check_output([fwxserver_loc,'-V']).decode("utf-8")
        fwxversion = fwxversion.replace('fwxserver ','')
        fwxversion = fwxversion.replace('\r','')
        fwxversion = fwxversion.replace('\n','')
        license_str = create_licstr(licensefile)
        timestr = str(now.month)+"_"+str(now.day)+"_"+str(now.year)+"_"+str(now.hour)+"_"+str(now.minute)
        datafilename = license_str +"-"+ fwxversion +"-"+ osinfo +"-"+timestr+".sql"
        print("Dumping MDM DB ...")
        mdm_dump = mdm_dump+str(datafilename)
        dump_db(pgdump,mdm_dump)
        print("Compressing MDM dump ... ")
        make_tarfile(mdm_dump+'.tar.gz', mdm_dump)
        print('File created with name : '+mdm_dump)

        # Upload the MDM dump to FileWave's SeaFile:
        r = requests.post('https://files.filewave.net/api2/auth-token/', {'username':'qa@filewave.com','password':'qaAut0m@t3'})
        if r.status_code != 200:
            print("There is an issue connecting to SeaFile from this Server. Please make sure the server is connected to the Internet or contact FileWave support to upload the MDM dump manually.")
        else:
            token = r.json()['token']
            #print(token)
            a = requests.get('https://files.filewave.net/api2/default-repo/', headers={'Authorization':'Token '+token})
            # Check if there are repos
            if a.json()['exists'] == False:
                print("There are no repos on SeaFile, create a repo to upload the MDM dump.")
            else:
                # Get the Upload link
                repoid = a.json()['repo_id']
                resp = requests.get('https://files.filewave.net/api2/repos/'+repoid+'/upload-link/', headers={'Authorization':'Token '+token})
                upload_link = resp.json()
                # Upload file to repo
                print("Uploading MDM dump to FileWave File Servers. This will take a while ...")
                response = requests.post(upload_link, data={'filename': str(datafilename)+'.tar.gz', 'parent_dir': '/'},files={'file': open(mdm_dump+'.tar.gz', 'rb')},headers={'Authorization': 'Token '+token})
                print(response)
                if response.status_code == 200:
                    print("File with name : "+str(datafilename)+".tar.gz uploaded successfully to FileWave File Servers. Please update your support ticket with this information.")
                else:
                    print("There is an issue uploading to SeaFile from this Server. Please make sure the server is connected to the Internet or upload the MDM dump manually.")
    except KeyError:
        print("An exception was thrown running this script. Please try again or contact your IT admin")
else:
    print("This script has to be run on your FileWave Server.")



