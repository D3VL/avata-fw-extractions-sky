#arcast_pro check usb flash disk path

if [ -d /media/usbsda ]; then
	echo "uDisk path /media/usbsda"
	exit 1
fi

if [ -d /media/usbsda1 ]; then
	echo "uDisk path /media/usbsda1"
	exit 2
fi

if [ -d /media/usbsdb ]; then
	echo "uDisk path /media/usbsdb"
	exit 3
fi

if [ -d /media/usbsdb1 ]; then
	echo "uDisk path /media/usbsdb1"
	exit 4
fi

if [ -d /media/usbsdc ]; then
	echo "uDisk path /media/usbsdc"
	exit 5
fi

if [ -d /media/usbsdc1 ]; then
	echo "uDisk path /media/usbsdc1"
	exit 6
fi

echo "find no uDisk"
exit 0
