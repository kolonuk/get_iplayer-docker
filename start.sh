#!/bin/bash
if [[ ! -f /root/get_iplayer.cgi ]]
then
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer
  chmod 755 /root/get_iplayer
fi

if [[ ! -f /root/.get_iplayer/options ]]
then
  echo No options file found, adding some nice defaults...
  /root/get_iplayer --prefs-add --whitespace
  /root/get_iplayer --prefs-add --subs-embed
  /root/get_iplayer --prefs-add --metadata
  /root/get_iplayer --prefs-add --nopurge
fi

echo Forcing output location...
/root/get_iplayer --prefs-add --output="/root/output/"

/usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer
