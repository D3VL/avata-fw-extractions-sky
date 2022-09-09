!/bin/sh

###############################################################
#                     config & paramters                      #
###############################################################
#start from mtd =1; OR; start form nfs = 0
mtd_mnt=1


#board_type  1:SRC  0:SINK
board_type=0

###############################################################
#                        functions                            #
###############################################################
board_cfg_gpio_num=23
function get_board_type()
{
	if [ ! -d /sys/class/gpio/gpio23 ]; then
		echo $board_cfg_gpio_num > /sys/class/gpio/export
	fi
	echo "in" > /sys/class/gpio/gpio23/direction
	return $(cat /sys/class/gpio/gpio23/value)
}

function auto_fsck_sky()
{
    if [ -e "/dev/mmcblk0p16" ]; then
        devstr="/dev/mmcblk0p16"
        umount /media/mmcblk0p16
    else
        echo "not find sd card"
        return
    fi

    echo "find sd card $devstr"
    devinfo=`blkid $devstr`
    echo "get devinfo=$devinfo"

    case $devinfo in
        *"vfat"*)
            echo "find vfat filesys"
            dosfsck -a $devstr
        ;;
        *"exfat"*)
            echo "find exfat filesys"
            fsck.exfat -vy $devstr
        ;;
    esac
}
function cfg_fpv_sky_board()
{
	if [ -e /local/usr/bin/fpv_sky_board_precfg ] ; then
		/local/usr/bin/fpv_sky_board_precfg
		return $?
	else
		return -1
	fi
}
##################################################################
#                        sys start                               #
##################################################################
# start the sceniaro for ipcam
export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/tmp/dbus-artosyn"

#boot dsp0
#ar_dsp_bootup 0 /local/usr/bin/ceva0_scalar.bin &

#check sys src or sink 
get_board_type
board_type=$?
if [ $board_type == 1 ];then
	echo "CUR_BOARD_TYPE:SRC"
    # start sd card
    #/sbin/insmod /mod/sdhci-artosyn.ko
else
	echo "CUR_BOARD_TYPE:SINK"
    # start sd card
    #/sbin/insmod /mod/sdhci-artosyn.ko 1
fi

# if has 8 paramters, means enter clean system, and $8 is flagfile
if [ $# == 8 ] || [ -e /local/sirius-clean-system-flag ]; then
    /etc/init.d/enumerate_sd_mount.sh
    ulseep 800000
	/etc/init.d/start_clean_system.sh $8
    #start network
    if [ $board_type == 1 ];then
    	/etc/init.d/usb_gadget_configfs.sh rndis+hid_arto+mass_storage src  0 0x1d6b 0x0104
    else
    	/etc/init.d/usb_gadget_configfs.sh rndis+hid_arto sink 0 0x1d6b 0x0104
    fi

    if [ -e "/mod/da9062_wdt.ko" ]; then
        insmod /mod/da9062_wdt.ko
    fi
  
#    if [ -e "/local/usr/bin/test_hid_service" ]; then
#        cp -f /local/usr/bin/test_hid_service /tmp/test_hid_service
#        /tmp/test_hid_service &
#    fi
    rm -f /local/sirius-clean-system-flag && sync
#	if [ -e /local/usr/sbin/dropbear ]; then
#        chmod +x /local/usr/bin/scp
#        chmod +x /local/usr/sbin/dropbear
#        cp /local/usr/bin/scp /usr/bin
#        cp /local/usr/sbin/dropbear /tmp/
#        /tmp/dropbear &
#    fi
  	exit 0
fi

ulimit -s 512
#start network
if [ $board_type == 1 ];then
	/etc/init.d/usb_gadget_configfs.sh rndis+hid_arto+mass_storage src  0 0x1d6b 0x0104
else
	/etc/init.d/usb_gadget_configfs.sh rndis+hid_arto sink 0 0x1d6b 0x0104
fi
#start eth
#etc/init.d/start_eth.sh
if [ -e /local/usr/sbin/dropbear ]; then
        chmod +x /local/usr/bin/scp
        chmod +x /local/usr/sbin/dropbear
        cp /local/usr/bin/scp /usr/bin
        cp /local/usr/sbin/dropbear /tmp/
        /tmp/dropbear
fi

#chmod -R 777 /local/factory/lowpower/*
usleep 700000
echo "merge user cfg file..."
/local/usr/bin/mergeUserConfig2sdk 2 6
echo "merge user cfg finisned"
#/local/factory/lowpower/start_lp.sh
#mount -t nfs -o nolock 192.168.200.6:/nfs_share/bshu /nfs
devmem 0x60632040 32 0x8c
all=
for i in $(seq 1 20)
do

    devmem 0x60632038 32 0x03
    let adc=$(devmem 0x60632810)
    all="$adc  $all"
					
done

echo "$all"

obj_adc=$(echo $all | tr ' ' '\n' | sort -n | awk '{print $1}' | sed -n "10p")

if [ $obj_adc -gt 313 ] && [ $obj_adc -lt 370 ]
then
        mkdir -p /usrdata/factory/sensor/cam_os02k10/                     
        cp /local/factory/sensor/cam_os02k10/cam_os02k10_06.cfg /usrdata/factory/sensor/cam_os02k10/cam_os02k10.cfg
        echo "sensor version(0.6V)"
elif [ $obj_adc -gt 142 ] && [ $obj_adc -lt 199 ]
then
        mkdir -p /usrdata/factory/sensor/cam_os02k10/                     
        cp /local/factory/sensor/cam_os02k10/cam_os02k10.cfg /usrdata/factory/sensor/cam_os02k10/cam_os02k10.cfg
        echo "sensor version(0.3V)"
else
	echo "no sensor ($obj_adc) ..."
fi
if [ $mtd_mnt == 1 ];then
	echo "run arcast"
	boot_assist /dev/$3 --size0 0xC000000 --cmdline "factory_dir=/local/factory/" &
else
	echo "run arcast from nfs"
	etc/init.d/start_eth.sh
	mount -t nfs -o nolock 192.168.200.6:/nfs_share/bshu /mnt
	boot_assist /mnt/a7_rtos.nonsec.img --size0 0x9000000 --cmdline "factory_dir=/local/factory/" &
	sleep 1
	rtcmd start_log &
fi

mkdir /record
auto_fsck_sky
cfg_fpv_sky_board
#BOARD_VER,0-6s2T2R,1-6s1T1R,2-1S1T1R
BOARD_VER=$?
echo "------>board_ver=$BOARD_VER"
fpv_sky_board_precfg --fpv_type $BOARD_VER --hwver
HW_VER=$?
echo "------->hw ver=$HW_VER"

#resolution 0: 1080p, 1:4K
resolution=0
while [ 1 ]; do
    if [ -e "/dev/ar_lancher" ]; then
        if [ -e "/local/usr/bin/fpv_ldy" ]; then
            echo "start fpv ldy"
			fpv_ldy --type sky --start_bitrate 10240 --fps 100 --width 1280 --height 720&
        else
            echo "no fpv app!!!!"
        fi
        break;
    fi
    sleep 1
done

if [ -e "/local/usr/bin/bb_cfg" ]; then
    chmod 777 /local/usr/bin/bb_cfg
    /local/usr/bin/bb_cfg &
fi

#enable framebuffer overlay, resolution should same as medical cam app
if [ $resolution == 0 ];then
    echo "insmod 1080p framebuffer"
    #/sbin/insmod /local/mod/ar_framebuffer.ko width=960 height=240 number=2 &
else
    echo "insmod 4k framebuffer"
    #/sbin/insmod /local/mod/ar_framebuffer.ko width=960 height=240 number=2 &
fi
#/local/factory/lowpower/end_lp.sh
if [ -e "/local/usr/bin/ar_dbg_service" ]; then
    if [ -e "/sys/kernel/config/usb_gadget/g1/functions/rndis.usb0" ]; then
        /local/usr/bin/ar_dbg_service $BOARD_VER &
        echo start ar_dbg_service with RNDIS
    else
        /local/usr/bin/ar_dbg_service $BOARD_VER &
        echo start ar_dbg_service without RNDIS
    fi
else
    echo no ar_dbg_service
fi
# startup live555 in sink board
if [ $board_type == 0 ];then
    if [ -e "/local/usr/bin/live555MediaServer" ]; then
       echo "run live555MediaServer"
       /local/usr/bin/live555MediaServer -c /local/factory/codec_cfg/live555_device.config&
    fi
fi

devmem 0x6068038c 32 0xd32
i2cset -f -y 0 0x58 0x0a3 0x38
i2cset -f -y 0 0x58 0x0a4 0x38

#i2cget -f -y 0 0x58 0x0a3
#i2cget -f -y 0 0x58 0x0a4

ifconfig lo up
usleep 100000

if [ -e "/local/usr/bin/test_hid_service" ]; then
    /local/usr/bin/test_hid_service &
fi

cp /local/shell/mkexfatfs /local/usr/bin/
chmod 777 /local/usr/bin/mkexfatfs

chmod 777 /local/shell/*
/local/shell/record_mount.sh &

fpv_sky_led &
#ar_fpv_service 0 &

fpv_sky_service -b $BOARD_VER -v $HW_VER &
bb_match -t 0 &

exit
