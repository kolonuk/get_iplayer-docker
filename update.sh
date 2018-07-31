#!/bin/bash

# Get cgi script version
if [[ -f /root/get_iplayer.cgi ]]
then
  VERSIONcgi = $(cat /root/get_iplayer.cgi | grep VERSION | grep -oP 'VERSION\ =\ \K.*?(?=;)' | head -1)
fi

# Get main script version
if [[ -f /root/get_iplayer ]]
then
  VERSION = $(cat /root/get_iplayer | grep version | grep -oP 'version\ =\ \K.*?(?=;)' | head -1)
fi

# Get current github release version
RELEASE = $(wget -q -O - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")')

# If no github version returned
if [[ "$RELEASE" -eq "" ]] && [[ "$FORCEDOWNLOAD" -eq "" ]]
then
  #indicates something wrong with the github call
  echo ******** Warning - unable to check latest release!!
  exit 1
fi

if [[ "$VERSION" -ne "$VERSIONcgi" ]] || \
   [[ "$VERSION" -eq "" ]] || \
   [[ "$VERSIONcgi" -eq "" ]] || \
   [[ "$VERSION" -ne "$RELEASE" ]] || \
   [[ "$FORCEDOWNLOAD" -ne "" ]]
then
  if [[ "$RELEASE" -eq "" ]]
  then
    # No release returned from github
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer
    chmod 755 /root/get_iplayer
  else
    # Download release
    wget https://github.com/get-iplayer/get_iplayer/archive/v$RELEASE.tar.gz -O /root/latest.tar.gz
    tar -xzf /root/latest.tar.gz --directory /root/
    rm /root/latest.tar.gz
  fi
  
  #This is a little harsh, but will do for now
  reboot
    
  #kill current get_iplayer gracefully (is pvr/cache refresh running?)
    
  #Spawn new get_iplayer
  #/root/start.sh &
fi
