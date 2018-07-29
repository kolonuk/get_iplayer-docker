FROM ubuntu

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install atomicparsley ffmpeg perl libjson-pp-perl libxml-perl libxml-libxml-simple-perl liblwp-protocol-https-perl libmojolicious-perl libcgi-fast-perl wget -y
RUN echo $'#!/bin/bash\n\
if [[ ! -f /root/get-iplayer.cgi ]]\n\
then\n\
  \#wget https://github.com/get-iplayer/get_iplayer/archive/v3.16.tar.gz -O /root/get_iplayer-latest.tar.gz\n\
  \#tar -xzf /root/get_iplayer-latest.tar.gz /root/\n\
  wget https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer.cgi -O /root/get_iplayer.cgi\n\
  wget https://raw.githubusercontent.com/get-iplayer/get_iplayer/master/get_iplayer -O /root/get_iplayer\n\
  chmod 744 /root/get_iplayer\n\
fi\n\
/root/get_iplayer --prefs-add --output="/root/output/"\n\
/usr/bin/perl /root/get_iplayer.cgi --port 8181 --getiplayer /root/get_iplayer\n\
' > /root/start.sh && chmod 777 /root/start.sh

VOLUME /root/.get_iplayer
VOLUME /root/output

LABEL maintainer="John Wood <john@kolon.co.uk>"

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
