#!/bin/sh

########################################################################
#==============this is a demo, do whatever you want to=================#
########################################################################

# add some ota-related applications here, such an ota server application.
# attentions: copy the applications to /tmp before running it.
# example:
# cp /local/usr/bin/foo /tmp
# /tmp/foo

# flagfile, can restore any information you want, such as image filename,
# so you can use artosyn_upgrade upgrade automatically

#flagfile=$1

# reboot need it
if [ -e "/local/usr/bin/ar_wdt_service" ]; then
	cp /local/usr/bin/ar_wdt_service /tmp
fi

LD_LIBRARY_PATH=/tmp:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
echo ${LD_LIBRARY_PATH}

if [ -e "/local/usr/bin/ar_fpv_upgrade" ]; then
    cp /local/usr/lib/* /tmp
    cp /local/usr/bin/ar_fpv_upgrade /tmp
    #/etc/init.d/export_leds.sh
    /tmp/ar_fpv_upgrade -r 1 &
fi

# reboot after 10min, if you have a different reboot command,
# replace "/tmp/ar_wdt_service -t 0" with your command
sleep 600 && /tmp/ar_wdt_service -t 0 &

if [ -f $1 ]; then
	rm $1
fi
