#!/bin/bash

# For all script types, returning an exit code of 0 ( success ) means the
# script execution completed successfully.
#
# If this is a requirements script, returning any other exit code but 0 will be
# reported as a "Requirements Failure: Script" in the Client Info window and
# Fileset Report. These same non-zero exit code (e.g. 1 or -1) will also
# prevent the contents of the fileset from downloading and installing.
#
# For other types of scripts, any non-zero exit code (e.g. 1 or -1) causes the
# fileset installation to fail and a script failure to be reported.
#
# If the script finishes without returning an exit code, the exit code 0
# ( success ) is assumed by default.
#
# Add the contents of your script below:

echo "Setting home URL"

set -e

echo "Creating request"
install_directory='cat /etc/pl_dir'

"$install_directory/service_interface/./PrinterInstallerClientService" set_home_url $1 $2 http printlogic.nafcs.pri 

exit 0
