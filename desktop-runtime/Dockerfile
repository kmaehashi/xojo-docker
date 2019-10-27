FROM ubuntu:16.04
LABEL maintainer "Kenichi Maehashi <webmaster@kenichimaehashi.com>"

RUN sed -i.bak -e 's|http://archive\.ubuntu\.com/ubuntu/|mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list && \
    apt-get -y update && \
    apt-get -y upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install ubuntu-desktop && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

RUN apt-get -y update && \
    apt-get -y install libc6 libncurses5 libstdc++6 libglib2.0-0 libsoup2.4-1 libgtk-3-0 libwebkitgtk-3.0-0 libunwind8 xvfb netcat-openbsd && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*

COPY headless /
