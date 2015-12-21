#!/bin/bash

ps aux | grep -i 'install os' > /dev/null
if [ $? -eq 0 ]; then
  echo "Process is running."
else
  echo "Process is not running."
fi
