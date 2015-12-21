#!/bin/bash

#log all to filewave client log

exec 1>>/var/log/fwcld.log

exec 2>>/var/log/fwcld.log


if [ -d /Applications/LinkNetworkHome.app ];
then
        if [ -e /Applications/LinkNetworkHome.app/Contents/Resources/GetFileInfo ];
        then
                echo "New LinkNetworkHome, Doing nothing ..."
        else
                echo "Old LinkNetworkHome found, Deleting it ..."
	            cd /Applications
	            rm -rf LinkNetworkHome.app

	            echo "Installing the new LinkNetworkHome version ..."
	            rsync -av /usr/local/etc/LinkNetworkHome.app /Applications
                echo "Done !"
        fi
else
        echo "LinkNetworkHome.app not in the /Applications Folder, Doing nothing ..."
fi