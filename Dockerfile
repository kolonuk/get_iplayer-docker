FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends atomicparsley ffmpeg perl libjson-pp-perl libxml-libxml-perl libcgi-pm-perl liblwp-protocol-https-perl libmojolicious-perl wget bash cron -y
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo $'\#!/bin/bash\n\
if [[ ! -f /root/get_iplayer.cgi ]]\n\
then\n\
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi\n\
  wget -q https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer\n\
  chmod 755 /root/get_iplayer\n\
fi\n\
if [[ ! -f /root/.get_iplayer/options ]]\n\
then\n\
  echo No options file found, adding some nice defaults...\n\
  /root/get_iplayer --prefs-add --whitespace\n\
  /root/get_iplayer --prefs-add --modes=tvbest,radiobest\n\
  /root/get_iplayer --prefs-add --subtitles\n\
  /root/get_iplayer --prefs-add --subs-embed\n\
  /root/get_iplayer --prefs-add --metadata\n\
fi\n\
echo Forcing output location...\n\
/root/get_iplayer --prefs-add --output="/root/output/"\n\
/usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer\n\
' > /root/start.sh && chmod 755 /root/start.sh

RUN crontab -l | { cat; echo "@hourly /root/get_iplayer --refresh --type=all --nopurge > /proc/1/fd/1 2>&1"; } | crontab -
RUN crontab -l | { cat; echo "@hourly /root/get_iplayer --type=all --pvr --nopurge > /proc/1/fd/1 2>&1"; } | crontab -

VOLUME /root/.get_iplayer
VOLUME /root/output

LABEL maintainer="John Wood <john@kolon.co.uk>"
LABEL issues_kolonuk/get_iplayer="Comments/issues for this dockerfile: https://github.com/kolonuk/get_iplayer/issues"
LABEL issues_get_iplayer="Comments/issues for get_iplayer: <a href=\"https://forums.squarepenguin.co.uk\"> here </a>"

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
