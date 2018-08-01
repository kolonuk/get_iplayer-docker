#!/bin/bash

# Pause a little while to allow docker logging to start properly
sleep 10

# Check if we have get_iplayer
if [[ ! -f /root/get_iplayer.cgi ]]
then
  /root/update.sh start
fi

# Set some nice defaults
if [[ ! -f /root/.get_iplayer/options ]]
then
  echo No options file found, adding some nice defaults...
  /root/get_iplayer --prefs-add --whitespace
  /root/get_iplayer --prefs-add --subs-embed
  /root/get_iplayer --prefs-add --metadata
  /root/get_iplayer --prefs-add --nopurge
fi

# Force output location to a separate docker volume
echo Forcing output location...
/root/get_iplayer --prefs-add --output="/root/output/"

if [[ -f /root/get_iplayer.cgi ]]
then
  /usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer
else
  sleep 99999 # when testing, keep container up long enough to check stuff out
fi

