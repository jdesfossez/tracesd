#!/bin/bash

source /etc/lsb-release
if [ "$DISTRIB_ID" != "Ubuntu" -o "$DISTRIB_RELEASE" != "14.04" ]; then
	echo "ERROR: Only Ubuntu 14.04 is supported."
	exit 1
fi

URCU_TAG=v0.7.12
UST_TAG=v2.4.1
MODULES_TAG=extended-network-fields
TOOLS_TAG=v2.4.1

mkdir ~/src
cd ~/src
apt-get -y install build-essential libtool flex bison libpopt-dev uuid-dev libglib2.0-dev autoconf git libxml2-dev
git clone git://git.lttng.org/lttng-ust.git
git clone https://github.com/jdesfossez/lttng-modules-dev.git
git clone git://git.lttng.org/lttng-tools.git
git clone git://git.lttng.org/userspace-rcu.git
git clone git://git.efficios.com/babeltrace.git
cd userspace-rcu
git checkout $URCU_TAG
./bootstrap && ./configure && make -j4 && sudo make install
sudo ldconfig
cd ../lttng-ust
git checkout $UST_TAG
./bootstrap && ./configure && make -j4 && sudo make install
sudo ldconfig
cd ../lttng-modules-dev
git checkout $MODULES_TAG
# XXX: ugly fix for Ubuntu kernel
sed -i 's/3,13,0/3,13,12/' instrumentation/events/lttng-module/block.h
make && sudo make modules_install
sudo depmod -a
cd ../lttng-tools
git checkout $TOOLS_TAG
./bootstrap && ./configure && make -j4 && sudo make install
sudo ldconfig
cd ../babeltrace
./bootstrap && ./configure && make -j4 && sudo make install
sudo ldconfig

cat <<EOF >/etc/init/lttng-sessiond.conf
description "LTTng 2.0 central tracing registry session daemon"
author "Stéphane Graber <stgraber@ubuntu.com>"

start on local-filesystems
stop on runlevel [06]

respawn
exec lttng-sessiond
EOF

cat <<EOF >/etc/init/lttng-relayd.conf
description "LTTng 2.0 relay daemon"
author "Stéphane Graber <stgraber@ubuntu.com>"

start on local-filesystems
stop on runlevel [06]

respawn
exec lttng-relayd -o /root/lttng-traces/
EOF

start lttng-sessiond
start lttng-relayd
