#!/bin/sh


# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

echo "start the sceniaro for" $1
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7


#boot a7 rtos
boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json --size0 0xB000000  &

sleep 2

insmod /mod/ar_cam.ko

# nfs setting example
#mkdir -p /nfs
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/klbai /nfs

#boot_assist /nfs/a7_rtos.nonsec.img fw_memory_layout.json &


# start dsp $ceva0_part $ceva1_part $ceva2_part $ceva3_part $5:dev interface $6: config
	/etc/init.d/start_dsp.sh /local/usr/bin/ceva0_hdr.bin /dev/null /dev/null /dev/null /dev/video_yuv-1.2 /local/usr/bin/std_ssd_config_hdr.ini &

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    echo "start dbg pc tool"
    /local/usr/bin/ar_dbg_service &
fi

/etc/init.d/usb_gadget_configfs.sh rndis 0 0 0x1d6b 0x0102


/etc/init.d/start_usbwifi.sh &

exit
