#!/bin/bash

# Get cgi script version
if [[ -f /root/get_iplayer.cgi ]]
then
  VERSIONcgi=$(cat /root/get_iplayer.cgi | grep VERSION | grep -oP 'VERSION\ =\ \K.*?(?=;)' | head -1)
fi

# Get main script version
if [[ -f /root/get_iplayer ]]
then
  VERSION=$(cat /root/get_iplayer | grep version | grep -oP 'version\ =\ \K.*?(?=;)' | head -1)
fi

# Get current github release version
RELEASE=$(wget -q -O - "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" | grep -Po '"tag_name": "v\K.*?(?=")')

# If no github version returned
if [[ "$RELEASE" == "" ]] && [[ "$FORCEDOWNLOAD" -eq "" ]]
then
  #indicates something wrong with the github call
  echo -e ******** Warning - unable to check latest release!!  Please raise an issue https://github.com/kolonuk/get_iplayer-docker/issues/new
fi

if [[ "$VERSION" != "$VERSIONcgi" ]] || \
   [[ "$VERSION" == "" ]] || \
   [[ "$VERSIONcgi" == "" ]] || \
   [[ "$VERSION" != "$RELEASE" ]] || \
   [[ "$FORCEDOWNLOAD" != "" ]]
then
  if [[ "$RELEASE" == "" ]]
  then
    # No release returned from github, download manually
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi
    wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer
    chmod 755 /root/get_iplayer
  else
    # Download and unpack release
    wget -q https://github.com/get-iplayer/get_iplayer/archive/v$RELEASE.tar.gz -O /root/latest.tar.gz
    tar -xzf /root/latest.tar.gz get_iplayer-$RELEASE --directory /root/ --strip-components=1
    rm /root/latest.tar.gz
  fi
  
  #kill current get_iplayer gracefully (is pvr/cache refresh running?)
  if [[ -f /root/.get_iplayer/pvr_lock ]] #|| [[ -f /root/.get_iplayer/??refreshcache_lock ]]
  then
    echo -e ****** Warning - updated scripts, but get_iplayer processes are running so unable to restart get_iplayer
  else
    # This will kill the running perl processes, and the start script will just re-load it
    killall -9 perl
  fi
fi
