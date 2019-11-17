FROM alpine:3.9

ADD start.sh /root/start.sh
ADD update.sh /root/update.sh

RUN apk --update add \
    bash \
    ffmpeg \
    openssl \
    perl-cgi \
    perl-mojolicious \
    perl-lwp-protocol-https \
    perl-xml-simple \
    perl-xml-libxml && \
    apk add atomicparsley --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && \
    chmod 755 /root/start.sh && \
    chmod 755 /root/update.sh && \
    echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin" > /root/cron.tab && \
    echo "@hourly /root/get_iplayer --refresh > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    echo "@hourly /root/get_iplayer --pvr > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    echo "@daily /root/update.sh > /proc/1/fd/1 2>&1" >> /root/cron.tab && \
    crontab /root/cron.tab && \
    rm -f /root/cron.tab

VOLUME /root/.get_iplayer
VOLUME /root/output

LABEL issues_get_iplayer="Comments/issues for get_iplayer: https://forums.squarepenguin.co.uk"
LABEL issues_kolonuk/get_iplayer="Comments/issues for this Dockerfile: https://github.com/kolonuk/get_iplayer-docker/issues"
LABEL maintainer="John Wood <john@kolon.co.uk>"

EXPOSE 8181:8181

ENTRYPOINT ["/bin/bash", "/root/start.sh"]
