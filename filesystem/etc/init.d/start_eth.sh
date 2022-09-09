#!/bin/sh
#
# Start the network
#

#disable ipv6
ifconfig lo up

echo 1 > /proc/sys/net/ipv6/conf/eth0/disable_ipv6

while [ ! -e "/tmp/factory_mount_end" ]; do
	#waiting factory mount done to check if mac avail
	usleep 100000
done

if [ -e "/factory/mac.cfg" ]; then
	echo "setting eth0 mac to eth0 "
	ifconfig eth0 hw ether `cat /factory/mac.cfg`
fi

/sbin/ifconfig eth0 up

#sleep to wait eth0
sleep 1

/sbin/udhcpc -b -i eth0 -s /etc/udhcpc.script -x lease:300 &

if [ -e /local/usr/sbin/dropbear ]; then
	chmod +x /local/usr/bin/scp
	chmod +x /local/usr/sbin/dropbear
	cp /local/usr/bin/scp /usr/bin
	cp /local/usr/sbin/dropbear /tmp/
	/tmp/dropbear 
fi

exit

