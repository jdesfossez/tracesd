#!/bin/bash

if test $# -lt 1; then
	echo "Usage : $0 <tracevisor hostname/ip>"
	exit 1
fi

TRACEVISORIP=$1
TRACEVISORPORT=5000

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y install git libavahi-client3 avahi-daemon libavahi-client-dev libavahi-common-dev make gcc curl
cd /usr/local/src
git clone https://github.com/jdesfossez/tracesd.git
cd tracesd
make
make install
cp upstart/tracesd.conf /etc/init
start tracesd
mkdir -p ~/.ssh
curl -s http://${TRACEVISORIP}:${TRACEVISORPORT}/trace/api/v1.0/ssh|grep tracevisor | cut -d '"' -f2 | cut -d "\\" -f1 >> ~/.ssh/authorized_keys2
