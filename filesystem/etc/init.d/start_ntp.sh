#!/bin/sh

# enable ntp funtion
if [ -e /usr/sbin/ntpd ]; then
	ntpd
fi
