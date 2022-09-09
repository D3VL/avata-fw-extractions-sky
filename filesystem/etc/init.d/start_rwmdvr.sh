#!/bin/sh

flag="/local/upgrade-flag"

echo "======================start xvr sh=========================="
/etc/init.d/tcpm_dp_fw_load.sh
# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

echo "start the sceniaro for" $1
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

# start ethernet....
/etc/init.d/start_eth.sh &
# tmp set ip addr
ifconfig eth0 192.168.1.110 up

if [ ! -f $flag ]; then
	/etc/poweron-upgrade.sh &
fi
# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	/etc/poweron-upgrade.sh
	exit 0
fi

echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7

#boot a7 rtos
boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json &

# start dsp $ceva0_part $ceva1_part $ceva2_part $ceva3_part $5:dev interface $6: config
# Set DSP frequency to 800MHz for test
ar_dsp_bootup 0 /local/usr/bin/ceva0_scalar.bin

if [ -e "/local/usr/bin/xvr_service" ]; then  
	xvr_service -t 0 -n 8 -fps 25 -res 720p -cam ahd -br 1536 -c &
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

# set GPIO for USB SATA, 76(B2-4) for reset, 78(B2-6) for Pwr
echo 76 > /sys/class/gpio/export 
echo 78 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio76/direction
echo out > /sys/class/gpio/gpio78/direction
echo 0 > /sys/class/gpio/gpio76/value
echo 0 > /sys/class/gpio/gpio78/value
sleep 1
echo 1 > /sys/class/gpio/gpio76/value
echo 1 > /sys/class/gpio/gpio78/value

echo 85 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio85/direction
echo 1 > /sys/class/gpio/gpio85/value

# set GPIO for USB2.0 SD
echo 82 > /sys/class/gpio/export 
echo 83 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio82/direction
echo out > /sys/class/gpio/gpio83/direction
echo 1 > /sys/class/gpio/gpio82/value
echo 1 > /sys/class/gpio/gpio83/value

exit
