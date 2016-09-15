#!/bin/sh

apache=$(pgrep httpd)

kill -9 $apache

exit 0
