#!/bin/sh

# start the sceniaro for ipcam

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	exit 0
fi

ulimit -s 512

#chmod -R 777 /local/factory/lowpower/*

#/local/factory/lowpower/start_lp.sh

echo "run arcastpro lowdelay"

boot_assist /dev/mtdblock14 /local/usr/bin/fw_memory_layout.json &

while [ 1 ]; do
    if [ -e "/dev/ar_lancher" ]; then
        if [ -e "/local/usr/bin/lowdelay" ]; then
            echo "start lowdelay"
            cp -f /local/usr/bin/lowdelay /tmp
			cp -f /local/usr/bin/ar_uart_cli /tmp
            cp -rf /local/usr/lib/* /lib/
            /tmp/lowdelay &
        else
            echo "no lowdelay app!!!!"
        fi
        break;
    fi
    sleep 1
done

#/local/factory/lowpower/end_lp.sh

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    if [ -e "/sys/kernel/config/usb_gadget/g1/functions/rndis.usb0" ]; then
        /local/usr/bin/ar_dbg_service --rndis &
        echo start ar_dbg_service with RNDIS
    else
        /local/usr/bin/ar_dbg_service &
        echo start ar_dbg_service without RNDIS
    fi
else
    echo no ar_dbg_service
fi

/tmp/ar_uart_cli &
exit
