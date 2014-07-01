#!/bin/bash

source /etc/lsb-release
if [ "$DISTRIB_ID" != "Ubuntu" -o "$DISTRIB_RELEASE" != "14.04" ]; then
	echo "ERROR: Only Ubuntu 14.04 is supported."
	exit 1
fi

apt-get update
apt-get -y install lttng-modules-dkms lttng-tools babeltrace
cp /etc/init/lttng-sessiond.conf /etc/init/lttng-relayd.conf
sed -i 's/sessiond/relayd/g' /etc/init/lttng-relayd.conf
start lttng-relayd
