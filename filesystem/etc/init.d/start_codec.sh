#!/bin/sh

# start the sceniaro for ipcam

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

# start ethernet....
/etc/init.d/start_eth.sh &

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	exit 0
fi

boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json &

#do prepare here, copy some user libs to /lib, these libs used for upgrade.


#mkdir -p /nfs
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/klbai /nfs
#boot_assist /nfs/a7_rtos.nonsec.img fw_memory_layout.json &

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    /local/usr/bin/ar_dbg_service &
else
    echo "no ar_dbg_service"
fi
#startup live555 media server
if [ -e "/local/usr/bin/live555MediaServer" ]; then
    /local/usr/bin/live555MediaServer &
else
    echo "no live555MediaServer"
fi

exit

