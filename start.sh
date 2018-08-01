#!/bin/bash

# Check if we have get_iplayer
if [[ ! -f /root/get_iplayer.cgi ]]
then
  /root/update.sh
fi

if [[ ! -f /root/get_iplayer ]]
then  # pause for checking things out...
  echo -e (1) Error occurred, pausing for 9999 seconds for investigation
  sleep 9999
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
  # Keep restarting - for when the get_iplayer script is updated
  while true
  do
    /usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer
  done 
else
  echo -e (2) Error occurred, pausing for 9999 seconds for investigation
  sleep 9999 # when testing, keep container up long enough to check stuff out
fi

