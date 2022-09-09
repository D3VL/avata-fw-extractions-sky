#!/bin/sh

# /etc/init.d/start_$gAPP.sh $gAPP $flashtype $a7rtos_part \
#	$ceva0_part $ceva1_part $ceva2_part $ceva3_part

/etc/init.d/tcpm_dp_fw_load.sh

echo "start the sceniaro for" $1

export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:/local/usr/lib/lib:."

# start ethernet....
/etc/init.d/start_eth.sh &

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ]; then
	/etc/init.d/start_clean_system.sh $8
	/etc/init.d/usb_gadget_configfs.sh hid_arto+serial+mass_storage 0 0 0x1d6b 0x0100
        if [ -e "/mod/da9062_wdt.ko" ]; then
                insmod /mod/da9062_wdt.ko
        fi

        if [ -e "/local/usr/bin/test_hid_service" ]; then
                cp -f /local/usr/bin/test_hid_service /tmp/test_hid_service
                /tmp/test_hid_service &
        fi
	exit 0
fi

#boot a7 rtos
boot_assist /dev/$3 /local/usr/bin/fw_memory_layout.json --size0 0xB000000 &
echo gAPP=$1 flashtype=$2 a7rtos_part=$3 \
	 ceva0_part=$4 ceva1_part=$5 ceva2_part=$6 ceva3_part=$7

#define isp function on ceva0 : null, eis, hdr
ceva0_isp_function=null
camera_fps=30

#sleep 10
# nfs setting example
#mkdir -p /nfs
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/klbai /nfs
#boot_assist /nfs/a7_rtos.nonsec.img fw_memory_layout.json &

usleep 200000

# start dsp $ceva0_part $ceva1_part $ceva2_part $ceva3_part $5:dev interface $6: config
if [ $ceva0_isp_function == eis ]; then
	/etc/init.d/start_dsp.sh /local/usr/bin/ceva0_eis.bin /dev/$5 /dev/null /dev/null /dev/video_yuv-0.2 /local/usr/bin/std_ssd_config_eis.ini &
elif [ $ceva0_isp_function == hdr ]; then
	/etc/init.d/start_dsp.sh /local/usr/bin/ceva0_hdr.bin /dev/$5 /dev/null /dev/null /dev/video_yuv-0.2 /local/usr/bin/std_ssd_config_hdr.ini &
else
	/etc/init.d/start_dsp.sh /dev/$4 /dev/$5 /dev/null /dev/null /dev/video_yuv-0.2 /local/usr/bin/std_ssd_config.ini &
fi;

#start ipcamera
if [ -e "/local/usr/bin/ipcam_service" ]; then
        echo "run /local/usr/bin/ipcam_service"
        /local/usr/bin/ipcam_service -t 0 --tee_copy 1 5 -w1 1920 -h1 1080 -w2 640 -h2 480 --$ceva0_isp_function --fps $camera_fps &
fi

if [ -e "/local/usr/bin/ar_dbg_service" ]; then
	echo "run ar_dbg_service"
	ar_dbg_service &
fi

if [ -e "/local/usr/bin/live555MediaServer" ]; then
	echo "run live555MediaServer"
	/local/usr/bin/live555MediaServer -c /local/usr/bin/live555_ipcam.config &
fi

if [ -e "/local/usr/bin/ar_wdt_service" ]; then
	cp /local/usr/bin/ar_wdt_service /tmp/
	echo "run ar_wdt_service"
	/tmp/ar_wdt_service -t 64 &
fi

#while [ 1 ]; do
#    if [ -e "/dev/icc_proxy_rpc_sink-1" ]; then
#        if [ -d "/mnt/usbsda1" ]; then
#            /local/usr/bin/snapshot_service -d "/dev/icc_proxy_rpc_sink-1" -p "/mnt/usbsda1" &
#        else
#            /local/usr/bin/snapshot_service -d "/dev/icc_proxy_rpc_sink-1" -p "/local" &
#        fi
#        break;
#    fi
#    sleep 1
#done

#/etc/init.d/start_usbwifi.sh &
exit
