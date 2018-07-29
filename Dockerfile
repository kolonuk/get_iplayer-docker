FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install atomicparsley ffmpeg perl libjson-pp-perl libxml-perl libxml-libxml-simple-perl liblwp-protocol-https-perl libmojolicious-perl libcgi-fast-perl wget bash -y
RUN echo $'\#!/bin/bash\n\
$current=$(cat /root/current)\n\
$latest = $(curl --silent "https://api.github.com/repos/get-iplayer/get_iplayer/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')\n\
echo Current version: $current, Latest version: $latest\n\
if [[ "$current" -ne "$latest" ]]\n\
then\n\
  $tarball = $(curl --silent "https://api.github.com/repos/$1/releases/latest" | grep -Po '"tarball_url": "\K.*?(?=")')\n\
  wget -q $tarball -O /root/latest.tar.gz &&\
  tar -xzf /root/latest.tar.gz -C /root/ &&\
  echo $current > /root/current\n\
fi\n\
if [[ ! -f /root/get_iplayer.cgi ]]\n\
then\n\
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi\n\
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer\n\
  chmod 744 /root/get_iplayer\n\
fi\n\
if [[ ! -f /root/.get_iplayer/options ]]\n\
then\n\
  echo No options file found, adding some nice defaults...\n\
  /root/get_iplayer --prefs-add --overwrite\n\
  /root/get_iplayer --prefs-add --force\n\
  /root/get_iplayer --prefs-add --whitespace\n\
  /root/get_iplayer --prefs-add --modes=tvbest,radiobest\n\
  /root/get_iplayer --prefs-add --subtitles\n\
fi\n\
echo Forcing output location...\n\
/root/get_iplayer --prefs-add --output="/root/output/"\n\
/usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer\n\
' > /root/start.sh && chmod 777 /root/start.sh

VOLUME /root/.get_iplayer
VOLUME /root/output

LABEL maintainer="John Wood <john@kolon.co.uk>"
LABEL issues_kolonuk/get_iplayer="Comments/issues for this dockerfile: https://github.com/kolonuk/get_iplayer/issues"
LABEL issues_get_iplayer="https://forums.squarepenguin.co.uk"

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
