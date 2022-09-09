#!/bin/sh

# mount record partition to /record, if failed, erase partition, mount again.


echo mounting recorid...

mkdir -p /record
record_num=$(cat /fdisk.info | grep record | awk '{print $1}')
record_size=$(cat /sys/block/mmcblk0/mmcblk0p$record_num/size)
if [ $record_size -lt 4096 ]
then
    echo dynimic upgrade record part size by differnet emmc size 
    artosyn_upgrade -u
    #/local/shell/reset.sh
    echo "------------ soc reset"
    i2cset -f -y 0 0x58 0x13 0x02
    exit
else
    echo no need resize record part
fi

check_mountpoint_failed_cnt=0
check_usb_err_cnt=0
mount_record_ok=0

check_umount_record() {
    if [ $mount_record_ok == 1 ]
    then
        umount /record
        if [ $? == 0 ]
        then
           mount_record_ok=0
        else
            echo umount record failed .............
        fi
        touch /tmp/flag_umount_record
    fi
    check_mountpoint_failed_cnt=0
}
while true
do
    usb_state=$(cat /sys/kernel/debug/60500000.dwc3/link_state)
    usb_mode=$(cat /sys/kernel/debug/60500000.dwc3/mode)
    if [ "$usb_mode" == "device" ]
    then
        if [ "$usb_state" == "U0" ] #usb config normal
        then
            check_umount_record
            usleep 100000
            check_usb_err_cnt=0 
            continue
        elif [ "$usb_state" == "SS.Disabled" ] #usb not plugin
        then
           check_usb_err_cnt=0 
        elif [ "$usb_state" == "U3" ] #usb config error, reconfig usb
        then
            check_umount_record
            check_usb_err_cnt=$(($check_usb_err_cnt+1))
            echo ...........usb config err................. $check_usb_err_cnt
            if [ $check_usb_err_cnt -gt 60 ]
            then
                #rm -rf /sys/kernel/config/usb_gadget/g1
                #usleep 20000
                #/etc/init.d/usb_gadget_configfs.sh rndis+mass_storage 0 0 0x1d6c 0x0105
                usleep 20000
                check_usb_err_cnt=0
            else
                sleep 1
            fi
            continue
        fi
    fi
    #if not check usb hotplug in, mount record 
    if [ $mount_record_ok == 0 ] 
    then
        fsck.exfat -vy /dev/mmcblk0p$record_num
        mount -t exfat /dev/mmcblk0p$record_num /record
        mountpoint /record
        if [ $? == 1 ]
        then
            check_mountpoint_failed_cnt=$(($check_mountpoint_failed_cnt+1))
            echo mount failed cnt $check_mountpoint_failed_cnt
            if [ $check_mountpoint_failed_cnt -gt 3 ]
            then
                check_mountpoint_failed_cnt=0
                echo format record part
                /local/usr/bin/mkexfatfs  /dev/mmcblk0p$record_num
                sleep 1
            else
                sleep 1
            fi
        else
            echo mount record ok
            mount_record_ok=1
            #break
        fi
    else
        usleep 100000
    fi
done

#after mounting factory partition, check if resources in factory.


#create flag factory mount end flag in /tmp
touch /tmp/record_mount_end

exit
