#!/bin/sh
# sd mount
sd_devs=`cd /dev && ls mmcblk*`
for dev in $sd_devs;do
    if [ ! -d "/media/$dev" ];then
        mkdir -p "/media/$dev"
        mount /dev/$dev /media/$dev >/dev/null 2>&1
        if [ $? -ne 0 ];then
            rm -rf "/media/$dev"
        fi
    fi
done
