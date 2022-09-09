#!/bin/sh
#
# Start the network....
#

#disable ipv6

insmod /mod/cfg80211.ko
insmod /mod/mac80211.ko
insmod /mod/rfkill-regulator.ko
insmod /mod/8189fs.ko
sleep 1
echo 1 > /proc/sys/net/ipv6/conf/wlan0/disable_ipv6
/sbin/ifconfig wlan0 up
sleep 1
mkdir -p /var/run
/usr/bin/wpa_supplicant -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf -B
sleep 3
/sbin/udhcpc -b -i wlan0 -s /etc/udhcpc.script -x lease:300 &
#ifconfig wlan0 192.168.1.49


if [ -e /local/usr/sbin/dropbear ]; then
        chmod +x /local/usr/bin/scp
        chmod +x /local/usr/sbin/dropbear
	cp /local/usr/bin/scp /usr/bin
        cp /local/usr/sbin/dropbear /tmp/
        /tmp/dropbear
fi

exit
