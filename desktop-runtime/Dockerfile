FROM ubuntu:20.04
LABEL maintainer "Kenichi Maehashi <webmaster@kenichimaehashi.com>"

RUN perl -pi.bak -e 's!http://(archive|security)\.ubuntu\.com/ubuntu/!mirror://mirrors.ubuntu.com/mirrors.txt!g' /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-desktop && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN apt-get -y update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install xvfb && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY headless /
