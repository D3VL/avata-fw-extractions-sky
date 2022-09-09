#!/bin/sh

# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

/etc/init.d/tcpm_dp_fw_load.sh

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

#boot a7 rtos
boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json &
echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7

#define isp function on ceva0 : null, eis, hdr
ceva0_isp_function=null
camera_fps=25

#sleep 10
# nfs setting example
#mkdir -p /nfs
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/klbai /nfs
#boot_assist /nfs/a7_rtos.nonsec.img fw_memory_layout.json &

usleep 200000

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
	echo "run ar_dbg_service"
	ar_dbg_service &
fi

if [ -e "/local/usr/bin/live555MediaServer" ]; then
	echo "run live555MediaServer"
	/local/usr/bin/live555MediaServer &
fi

if [ -e "/local/usr/bin/ipcam_service" ]; then
    echo "start uvc server 0"
    /local/usr/bin/ipcam_service --multi -t 0 -w1 1920 -h1 1080 --$ceva0_isp_function --fps $camera_fps -index 0 &
    echo "start uvc server 1"
    /local/usr/bin/ipcam_service --multi -t 0 -w1 1920 -h1 1080 --$ceva0_isp_function --fps $camera_fps -index 1 &
    echo "start uvc server 2"
    /local/usr/bin/ipcam_service --multi -t 0 -w1 1920 -h1 1080 --$ceva0_isp_function --fps $camera_fps -index 2 &
    echo "start uvc server 3"
    /local/usr/bin/ipcam_service --multi -t 0 -w1 1920 -h1 1080 --$ceva0_isp_function --fps $camera_fps -index 3 &
    echo "start uvc server 4"
    /local/usr/bin/ipcam_service --multi -t 0 -w1 1920 -h1 1080 --$ceva0_isp_function --fps $camera_fps -index 4 &
fi


#/etc/init.d/start_usbwifi.sh &
exit
