#!/bin/bash

source /etc/lsb-release
if [ "$DISTRIB_ID" != "Ubuntu" ]; then
	echo "ERROR: Only Ubuntu is supported."
	exit 1
fi

apt-add-repository ppa:lttng/ppa

apt-get update
apt-get -y install lttng-modules-dkms lttng-tools babeltrace
