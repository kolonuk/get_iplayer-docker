FROM kolonuk/get_iplayer-docker-base

ADD start.sh /root/start.sh
ADD update.sh /root/update.sh

RUN chmod 755 /root/start.sh
RUN chmod 755 /root/update.sh

RUN crontab -l | { cat; echo "@hourly /root/get_iplayer --refresh > /proc/1/fd/1 2>&1"; } | crontab -
RUN crontab -l | { cat; echo "@hourly /root/get_iplayer --pvr > /proc/1/fd/1 2>&1"; } | crontab -
# Run update script every day
RUN crontab -l | { cat; echo "@daily /root/update.sh > /proc/1/fd/1 2>&1"; } | crontab -

VOLUME /root/.get_iplayer
VOLUME /root/output

LABEL maintainer="John Wood <john@kolon.co.uk>"
LABEL issues_kolonuk/get_iplayer="Comments/issues for this dockerfile: https://github.com/kolonuk/get_iplayer/issues"
LABEL issues_get_iplayer="Comments/issues for get_iplayer: <a href=\"https://forums.squarepenguin.co.uk\"> here </a>"

EXPOSE 8181

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
