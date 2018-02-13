import os, sys
import platform
import subprocess
import shutil
import getpass
import datetime
import tempfile
import tarfile
import re
import zipfile


unix_mdm_dump = '/tmp/mdm-dump.sql'
win_mdm_dump = ''
unix_pgdump = '/usr/local/filewave/postgresql/bin/pg_dump'
win_pgdump = ''

mdm_dump = ''
pgdump = ''

# Function to compress files.
def make_tarfile(output_filename, source_dir):
    with tarfile.open(output_filename, "w:gz") as tar:
        tar.add(source_dir, arcname=os.path.basename(source_dir))


# Renames the mdm dump if it already exists.
def rename_mdm_dump(mdmdump):
    if os.path.exists(mdmdump):
        print("File "+mdmdump+" already exists. Renaming...")
        os.rename(mdmdump, mdmdump+'_OLD')


# Gets the MDM dump.
def dump_db(pgdump_location,mdm_dump_location):
    try:
        p = subprocess.Popen([pgdump_location,"-U","django","--encoding=UTF8","-c","-f",mdm_dump_location,"-N","committed_*","mdm"],stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        out,err = p.communicate()
        #print("Output :\n",out)
    except Exception:
        print("There was an error dumping the Data Base :\n",err)
        print("Return Code :\n",p.returncode)


# Check what OS the server is running on
if os.name == 'posix' and (platform.system() == 'Darwin' or platform.system() == 'Linux' or  platform.system() == 'Linux2'):
    print("This is a Unix OS : "+platform.system())
    mdm_dump = unix_mdm_dump
    pgdump = unix_pgdump
else:
    print("This is Windows")
    mdm_dump = win_mdm_dump
    pgdump = win_pgdump

print("Renaming mdm dump file if there is one ...")
rename_mdm_dump(mdm_dump)
print("Dumping customer DB ...")
dump_db(pgdump,mdm_dump)
print("Compressing mdm dump ... ")
make_tarfile('mdm-dump.tar.gz', mdm_dump)



