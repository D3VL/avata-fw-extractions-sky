#!/bin/sh

# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	exit 0
fi

#ulimit -s 512

echo "start the sceniaro for" $1

boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json &

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7

#test_cam_src --name 0 --enable_mirror 1
#test_cam_src --name 0 --enable_flip 1
#test_cam_src --name 1 --enable_mirror 1
#test_cam_src --name 1 --enable_flip 1
#sleep 10

while [ 1 ];do
	if [ -e /dev/multimedia_core ]; then
		break;
	fi
	sleep 1
done

/etc/init.d/start_usbwifi.sh &

ar_sweeper_data_center &
#arp2p CLYA8T1MRNBWBMPGU1PJ 1 &

#ceva0_isp_function=hdr
if [ $ceva0_isp_function == hdr ];then
	/etc/init.d/start_dsp.sh /local/usr/bin/ceva0_hdr.bin /dev/$5 /dev/null /dev/null /dev/video_yuv-1.2 /local/usr/bin/sweeper_ssd_config_hdr.ini &
        ar_sweeper_service -t 1 -n 2 --hdr & 
else
	/etc/init.d/start_dsp.sh /dev/$4 /dev/null /dev/null /dev/null /dev/video_yuv-1.2 /local/usr/bin/sweeper_ssd_config.ini &
        ar_sweeper_service -t 1 -n 2  & 
fi;


sleep 3

live555MediaServer &

#arslam /local/usr/bin/arvoc.bin /local/usr/bin/config.yaml 300 &

wifi_client &

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    echo "start dbg pc tool"
    /local/usr/bin/ar_dbg_service &
fi

exit

