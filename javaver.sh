#!/bin/bash

# First check to see that there's a Java Plugin to read from
if [ -f "/Library/Internet Plug-Ins/JavaAppletPlugin.plugin/Contents/Info.plist" ]; then
    # Now read the Java version of the plugin
    echo "Getting the java version ..."
    JAVAVERS=$(defaults read /Library/Internet\ Plug-Ins/JavaAppletPlugin.plugin/Contents/Info.plist CFBundleVersion)
    # Tell fwcld to set the value to the inventory file
    echo "Java version is $JAVAVERS"
    /usr/local/sbin/FileWave.app/Contents/MacOS/fwcld -custom_write -key custom_string_06 -value "$JAVAVERS"
fi
exit 0
