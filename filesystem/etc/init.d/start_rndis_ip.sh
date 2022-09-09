#!/bin/sh
#
# Start rndis host network
#

#usb_type = "device"

#usb type 0:device 1:host
###############################################################
#                        functions                            #
###############################################################
function get_usb_type()
{
    usb_type=`cat /sys/kernel/debug/60500000.dwc3/mode`
    echo "usb type $usb_type"
    if [ x$usb_type == x"device" ]; then
	return 1
    else
	return 2
    fi
}


#board_type  0:SRC  1:SINK
board_type=$1

rndis_started=0
while [ 1 ]; do
    sleep 1
    /sbin/ifconfig -a |grep usb0 >/dev/null
    if [ $? == 0 ];then
        if [ $rndis_started == 0 ]; then
            if [ $board_type == 0 ]; then 
                /sbin/ifconfig usb0 up
                /sbin/ifconfig usb0 192.168.3.100
                echo "config src board usb0 rndis as device done, ip 192.168.3.100!"
	    else
	        get_usb_type
                if [ $? == 1 ]; then 
                    /sbin/ifconfig usb0 up
                    /sbin/ifconfig usb0 172.16.3.100
                    echo "config sink board usb0 rndis as device done, ip 172.16.3.100!"
                else
            	    /sbin/ifconfig usb0 up
                    /sbin/ifconfig usb0 192.168.42.100
                    #/sbin/udhcpc -b -i usb0 -s /etc/udhcpc.script -x lease:300 &
                    echo "config sink board usb0 rndis as host done!"
                fi
	    fi
            rndis_started=1
            echo "config usb0 rndis done!"
        else
            continue
        fi
    else
        if [ $rndis_started == 1 ]; then
            rndis_started=0
            echo "usb0 rndis disconnect!"
        fi
        continue
    fi
done
		
