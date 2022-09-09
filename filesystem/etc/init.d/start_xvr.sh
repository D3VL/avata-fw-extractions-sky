#!/bin/sh

/etc/init.d/tcpm_dp_fw_load.sh

echo "======================start xvr sh=========================="
# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

echo "start the sceniaro for" $1
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

# start ethernet....
/etc/init.d/start_eth.sh &

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	exit 0
fi

echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7

#boot a7 rtos
boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json &
#sleep 5
# nfs setting example
#mkdir -p /nfs
#echo "mounting"
#mount -t nfs -o nolock 192.168.200.232:/nfs_share/youlu /nfs
#echo "mounted"
#boot_assist /local/usr/bin/a7_rtos.nonsec.img /local/usr/bin/fw_memory_layout.json &

# start dsp $ceva0_part $ceva1_part $ceva2_part $ceva3_part $5:dev interface $6: config
ar_dsp_bootup 0 /local/usr/bin/ceva0_scalar.bin

if [ -e "/local/usr/bin/xvr_service" ]; then  
	xvr_service -t 0 -n 8 -fps 25 -res 1080p -cam ahd -br 1536 -c -disp 1920 1080 60 &
	sleep 2
fi

if [ -e "/local/usr/bin/live555MediaServer" ]; then                                                           
        live555MediaServer -c /local/usr/bin/live555_xvr.config &                                                               
fi

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    echo "start dbg pc tool"
    /local/usr/bin/ar_dbg_service &
fi

while [ 1 ]; do
 if [ -e "/dev/ar_overlay" ]; then
    echo " insmod ar_framebuffer.ko "
    insmod mod/ar_framebuffer.ko &
    break;
 else
    echo " wait insmod ar_framebufer.ko"
    sleep 1
 fi
done

chmod +x /local/usr/bin/xvr_cmd_ui

exit
