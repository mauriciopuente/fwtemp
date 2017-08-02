#!/bin/bash

awk '/SELF_HEAL_APPS_BY_VERSION/ {print ""; next} /./' /usr/local/filewave/django/filewave/settings_custom.py > /usr/local/filewave/django/filewave/settings_custom.py_BAK2 && mv -f /usr/local/filewave/django/filewave/settings_custom.py_BAK2 /usr/local/filewave/django/filewave/settings_custom.py

chmod 755 /usr/local/filewave/django/filewave/settings_custom.py

/usr/local/filewave/apache/bin/apachectl graceful
