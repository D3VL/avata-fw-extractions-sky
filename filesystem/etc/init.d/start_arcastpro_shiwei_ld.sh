#!/bin/sh

# start the sceniaro for ipcam

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"
ulimit -s 512

# start ethernet....
/etc/init.d/start_eth.sh &

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	exit 0
fi

echo "run arcastpro-shiwei lowdelay"
boot_assist /dev/mtdblock14 /local/usr/bin/fw_memory_layout.json &
while [ 1 ]; do
    if [ -e "/dev/ar_lancher" ]; then
        if [ -e "/local/usr/bin/lowdelay" ]; then
            echo "start lowdelay shiwei"
            cp -f /local/usr/bin/lowdelay /tmp
			cp -f /local/usr/bin/ar_uart_cli /tmp
            cp -rf /local/usr/lib/* /lib/
            /tmp/lowdelay -c 1 &
        else
            echo "no lowdelay app!!!!"
        fi
        break;
    fi
    sleep 1
done
if [ -e "/local/usr/bin/hdmi_rx_app" ]; then
    echo "start hdmi tx app"
    /local/usr/bin/hdmi_rx_app &
else
    echo "no hdmi rx app!!!!"
fi
sleep 1
if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    if [ -e "/sys/kernel/config/usb_gadget/g1/functions/rndis.usb0" ]; then
        /local/usr/bin/ar_dbg_service --rndis &
        echo start ar_dbg_service with RNDIS
    else
        /local/usr/bin/ar_dbg_service &
        echo start ar_dbg_service without RNDIS
    fi
else
    echo "no ar_dbg_service"
fi
sleep 1
/tmp/ar_uart_cli &
sleep 1
/usr/sbin/i2cset -y -f 0 0x58  0x9F 0xC0
/usr/sbin/i2cset -y -f 0 0x58  0xA0 0xC0
/usr/sbin/i2cset -y -f 0 0x58  0x9E 0xC0
/usr/sbin/i2cset -y -f 0 0x58  0x9D 0xC0
/usr/sbin/i2cset -y -f 0 0x58  0xA0 0xC0
/usr/sbin/i2cset -y -f 0 0x58  0x28 0x00
/usr/sbin/i2cset -y -f 0 0x58  0x29 0x00
#only for debug
#mkdir -p /nfs
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/klbai /nfs

exit
