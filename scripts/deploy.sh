#!/bin/bash

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install git libavahi-client3 avahi-daemon libavahi-client-dev libavahi-common-dev make gcc
cd /usr/local/src
git clone https://github.com/jdesfossez/tracesd.git
cd tracesd
make
make install
cp upstart/tracesd.conf /etc/init
start tracesd
