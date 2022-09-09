#!/bin/bash
while [ ! -e "/sys/class/udc/60500000.dwc3" ]
do
	usleep 10000
done

touch /tmp/usb_gadget_ok
sync

while [ e "/tmp/usb_gadget_ok" ]
do
        usleep 100000
done
