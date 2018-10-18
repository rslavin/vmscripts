#!/bin/bash

NET_CONFIG="/etc/netplan/50-cloud-init.yaml"

OLD_IP='10\.100\.118\.101'

if [[ $# -ne 2 ]]
then
	echo "Usage: $0 <new_hostname> <new_ip_address>"
	exit 1
fi

sed -i 's/preserve_hostname: false/preserve_hostname: true/' /etc/cloud/cloud.cfg
sed -i "1 s/^.*$/$1/g" /etc/hostname
sed -i -E "s/[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(\/[0-9]+)/$2\1/" $NET_CONFIG
hostnamectl set-hostname $1
netplan apply
sleep 2

echo "### Updates applied: ###"
hostnamectl
echo "### IP updated: ###"
ifconfig
echo "Restart required!"
