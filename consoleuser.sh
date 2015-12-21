#!/bin/bash


if [[ $(who | grep -i "console") ]]; then
    echo "there is a user logged in"
else
    echo "no users logged in"
fi

