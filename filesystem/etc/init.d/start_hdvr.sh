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
# audio powen on and select cam audio 8 in 1
gpio_config -e A2_7
gpio_config -e A4_2
gpio_config -e A4_3
gpio_config -e A4_4
gpio_config -s A2_7 -d output -l high
gpio_config -s A4_2 -d output -l low
gpio_config -s A4_3 -d output -l low
gpio_config -s A4_4 -d output -l low
if [ -e "/local/usr/bin/xvr_service" ]; then  
	xvr_service -t 0 -n 8 -fps 25 -res 720p -cam ahd -br 1536 -c -disp 1280 720 30 &
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

# set GPIO for USB hub
gpio_config -e A0_5
gpio_config -s A0_5 -d output -l high

# set GPIO for SD card
gpio_config -e B2_5
gpio_config -s B2_5 -d output -l high

# set GPIO for USB SATA, B2-4 for reset, C1-7 for Pwr
gpio_config -e C1_7
gpio_config -s C1_7 -d output -l high

gpio_config -e B2_4
gpio_config -s B2_4 -d output -l low
sleep 1
gpio_config -s B2_4 -d output -l high


exit
