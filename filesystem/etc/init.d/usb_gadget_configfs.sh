#!/bin/sh
#
# start config usb gadget configfs

#set -v

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_mjpeg()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/dwMaxBitRate
	echo $((${2}*${3}*2)) > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/dwMaxVideoFrameBufferSize
	echo ${4} > functions/uvc.usb$uvc_index/streaming/mjpeg/m/${1}/dwDefaultFrameInterval
}

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_h265()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/dwMaxBitRate
	echo ${4} > functions/uvc.usb$uvc_index/streaming/framebased/h265/${1}/dwDefaultFrameInterval
}

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_h264()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/dwMaxBitRate
	echo ${4} > functions/uvc.usb$uvc_index/streaming/framebased/h264/${1}/dwDefaultFrameInterval
}

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_nv12()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/dwMaxBitRate
	echo $((${2}*${3}*2)) > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/dwMaxVideoFrameBufferSize
	echo ${4} > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/${1}/dwDefaultFrameInterval
}

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_yuy2()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/dwMaxBitRate
	echo $((${2}*${3}*2)) > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/dwMaxVideoFrameBufferSize
	echo ${4} > functions/uvc.usb$uvc_index/streaming/uncompressed/yuy2/${1}/dwDefaultFrameInterval
}

# $1 FrameIndex $2 Width $3 Height $4 Interval1 $5 Interval2 ... ${11} Interval8
function make_format_z16()
{
	mkdir -p functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}
	cat <<-EOF > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/dwFrameInterval
	${4}
	${5}
	${6}
	${7}
	${8}
	${9}
	${10}
	${11}
	EOF

	#echo ${1} > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/bFrameIndex
	echo ${2} > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/wWidth
	echo ${3} > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/wHeight
	echo $((${2}*${3}*80)) > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/dwMinBitRate
	echo $((${2}*${3}*160)) > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/dwMaxBitRate
	echo $((${2}*${3}*2)) > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/dwMaxVideoFrameBufferSize
	echo ${4} > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/${1}/dwDefaultFrameInterval
}

echo USB_CONFIGFS: start ...

gUSB_GADGET_CONFIGFS=$1

if [ $gUSB_GADGET_CONFIGFS == none ]; then
	exit
fi

rndis_index=0
uvc_index=0
hid_index=0
mass_storage_index=0
uac1_index=0
serial_index=0
adbd_index=0
sourcesink_index=0
func_index=1

if [[ "$3" == "cdns3" ]]; then
	if [ -e "/sys/class/udc/60300000.cadence_usb" ]; then
		echo get udc 60300000.cadence_usb
	else
		exit
	fi
else
	if [ -e "/sys/class/udc/60500000.dwc3" ]; then
		echo get udc 60500000.dwc3
	else
		exit
	fi
fi

mount -t configfs none /sys/kernel/config
mkdir /sys/kernel/config/usb_gadget/g1
chmod -R 0770 /sys/kernel/config/usb_gadget/g1
echo $4 > /sys/kernel/config/usb_gadget/g1/idVendor
echo $5 > /sys/kernel/config/usb_gadget/g1/idProduct
echo 0x0310 > /sys/kernel/config/usb_gadget/g1/bcdDevice
echo 0x0200 > /sys/kernel/config/usb_gadget/g1/bcdUSB

mkdir /sys/kernel/config/usb_gadget/g1/strings/0x409
chmod -R 0770 /sys/kernel/config/usb_gadget/g1/strings/0x409
echo ZBBM5DZFMP > /sys/kernel/config/usb_gadget/g1/strings/0x409/serialnumber
echo Artosyn > /sys/kernel/config/usb_gadget/g1/strings/0x409/manufacturer
echo Sirius > /sys/kernel/config/usb_gadget/g1/strings/0x409/product

mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1
chmod -R 0770 /sys/kernel/config/usb_gadget/g1/configs/b.1
mkdir /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409
chmod -R 0770 /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409

echo 1 > /sys/kernel/config/usb_gadget/g1/os_desc/use
echo 0x1 > /sys/kernel/config/usb_gadget/g1/os_desc/b_vendor_code
echo "MSFT100" > /sys/kernel/config/usb_gadget/g1/os_desc/qw_sign

echo 500 > /sys/kernel/config/usb_gadget/g1/configs/b.1/MaxPower

funcs=${gUSB_GADGET_CONFIGFS//+/' '}
for word in $funcs
do
	case $word in
	rndis)
		echo USB_CONFIGFS: RNDIS rndis_index $rndis_index func_index $func_index
		mkdir /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index
		echo "RNDIS" > /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index/os_desc/interface.rndis/compatible_id
		echo "5162001" > /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index/os_desc/interface.rndis/sub_compatible_id
		ln -s /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
		if [[ "$2" == "src" ]]; then
			echo DA:AB:C2:D0:2F:F5 > /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index/dev_addr
		fi
		if [[ "$2" == "sink" ]]; then
			echo DA:AB:C2:D0:2F:F6 > /sys/kernel/config/usb_gadget/g1/functions/rndis.usb$rndis_index/dev_addr
		fi
		rndis_index=$(( $rndis_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;

	uvc|uvc_4k|uvc_3072|uvc_1792|uvc_1536)
		echo USB_CONFIGFS: UVC uvc_index $uvc_index func_index $func_index
		mkdir /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index

		if [[ "$2" == "cdns3" ]] || [[ "$3" == "cdns3" ]]; then
			echo 1024 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
			echo 0    > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxburst
		elif [[ $word == "uvc_3072" ]]; then
			echo 3072 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		elif [[ $word == "uvc_1792" ]]; then
			echo 1792 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		elif [[ $word == "uvc_1536" ]]; then
			echo 1536 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		elif [[ $word == "uvc_4k" ]]; then
			echo 3072 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
			echo 7    > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxburst
		else
			echo 2048 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		fi

		echo "UVC Camera $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/control_interface_name
		echo "Video Streaming $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_interface_name

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/control/header/h
		cd functions/uvc.usb$uvc_index/control/

		ln -s header/h class/fs
		ln -s header/h class/ss
		cd /sys/kernel/config/usb_gadget/g1/

		echo 0xEF > bDeviceClass
		echo 0x02 > bDeviceSubClass
		echo 0x01 > bDeviceProtocol
		echo 0x0409 > bcdDevice
		echo 0xC0 > configs/b.1/bmAttributes
		echo 0x01 > configs/b.1/MaxPower

		make_format_mjpeg 1  640  480 333333 400000
		make_format_mjpeg 2  320  240 333333 400000
		make_format_mjpeg 3  800  600 333333 400000
		make_format_mjpeg 4 1280  720 333333 400000
		make_format_mjpeg 5 1280  960 333333 400000
		make_format_mjpeg 6 1920 1080 333333 400000

		#################################exmaple NV12################################
		make_format_nv12 1  640  480 333333 400000
		make_format_nv12 2  320  240 333333 400000
		make_format_nv12 3  800  600 333333 400000
		make_format_nv12 4 1280  720 333333 400000
		make_format_nv12 5 1280  960 333333 400000
		make_format_nv12 6 1920 1080 333333 400000
		echo 12 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/bBitsPerPixel
		echo -ne \\x4e\\x56\\x31\\x32\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/guidFormat

		#################################example YUY2################################
		make_format_yuy2 1  640  480 333333 400000
		make_format_yuy2 2  320  240 333333 400000
		make_format_yuy2 3  800  600 333333 400000
		make_format_yuy2 4 1280  720 333333 400000
		make_format_yuy2 5 1280  960 333333 400000
		make_format_yuy2 6 1920 1080 333333 400000

		#################################example Z16################################
		make_format_z16 1  640  480 333333 400000
		make_format_z16 2  320  240 333333 400000
		make_format_z16 3  800  600 333333 400000
		make_format_z16 4 1280  720 333333 400000
		make_format_z16 5 1280  960 333333 400000
		make_format_z16 6 1920 1080 333333 400000
		echo -ne \\x5a\\x31\\x36\\x20\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/guidFormat

		#################################example H264################################
		make_format_h264 1  640  480 333333 400000
		make_format_h264 2  320  240 333333 400000
		make_format_h264 3  800  600 333333 400000
		make_format_h264 4 1280  720 333333 400000
		make_format_h264 5 1280  960 333333 400000
		make_format_h264 6 1920 1080 333333 400000

		#################################example H265################################
		make_format_h265 1  640  480 333333 400000
		make_format_h265 2  320  240 333333 400000
		make_format_h265 3  800  600 333333 400000
		make_format_h265 4 1280  720 333333 400000
		make_format_h265 5 1280  960 333333 400000
		make_format_h265 6 1920 1080 333333 400000
		echo -ne \\x48\\x45\\x56\\x43\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/framebased/h265/guidFormat

		if [[ $word == "uvc_4k" ]]; then
			make_format_mjpeg 7 3840 2160 333333 400000
			make_format_nv12  7 3840 2160 333333 400000
			make_format_yuy2  7 3840 2160 333333 400000
			#make_format_h264  7 3840 2160 333333 400000 #h264 encoder not support 4k
			make_format_h265  7 3840 2160 333333 400000
		fi

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/streaming/header/h
		cd functions/uvc.usb$uvc_index/streaming/header/h
		#ln -s ../../framebased/h265
		ln -s ../../framebased/h264
		ln -s ../../mjpeg/m
		ln -s ../../uncompressed/nv12
		ln -s ../../uncompressed/yuy2
		#ln -s ../../uncompressed/z16
		cd ../../class/fs
		ln -s ../../header/h
		cd ../../class/hs
		ln -s ../../header/h
		cd ../../class/ss
		ln -s ../../header/h

		ln -s /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
		uvc_index=$(( $uvc_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;

	uvc_hdr|uvc_hdr_1792|uvc_hdr_1536)
		echo USB_CONFIGFS: UVC uvc_index $uvc_index func_index $func_index
		mkdir /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index

		if [[ "$2" == "cdns3" ]] || [[ "$3" == "cdns3" ]]; then
			echo 1024 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
			echo 0    > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxburst
		elif [[ $word == "uvc_hdr_1792" ]]; then
			echo 1792 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		elif [[ $word == "uvc_hdr_1536" ]]; then
			echo 1536 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		else
			echo 2048 > /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		fi

		echo "UVC Camera $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/control_interface_name
		echo "Video Streaming $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_interface_name

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/control/header/h
		cd functions/uvc.usb$uvc_index/control/

		ln -s header/h class/fs
		ln -s header/h class/ss
		cd /sys/kernel/config/usb_gadget/g1/

		echo 0xEF > bDeviceClass
		echo 0x02 > bDeviceSubClass
		echo 0x01 > bDeviceProtocol
		echo 0x0409 > bcdDevice
		echo 0xC0 > configs/b.1/bmAttributes
		echo 0x01 > configs/b.1/MaxPower

		make_format_mjpeg 1  640  480 400000
		make_format_mjpeg 2  320  240 400000
		make_format_mjpeg 3  800  600 400000
		make_format_mjpeg 4 1280  720 400000
		make_format_mjpeg 5 1280  960 400000
		make_format_mjpeg 6 1920 1080 400000

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/streaming/header/h
		cd functions/uvc.usb$uvc_index/streaming/header/h
		#ln -s ../../framebased/h265
		#ln -s ../../framebased/h264
		ln -s ../../mjpeg/m
		#ln -s ../../uncompressed/nv12
		#ln -s ../../uncompressed/yuy2
		cd ../../class/fs
		ln -s ../../header/h
		cd ../../class/hs
		ln -s ../../header/h
		cd ../../class/ss
		ln -s ../../header/h

		ln -s /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
		uvc_index=$(( $uvc_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;

	uvc_bulk_*)
		echo USB_CONFIGFS: UVC uvc_index $uvc_index func_index $func_index
		mkdir /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index

		param=${word//_/' '}
		i=0
		payload=0

		for val in $param
		do
			if [[ $i == 2 ]]; then
				burstnum=$val
			fi
			if [[ $i == 3 ]]; then
				mode=$val
			fi
			let "i+=1"
		done

		let "payload=(burstnum+1)*1024*4"
		echo burstnum:$burstnum mode:$mode payload:$payload

		echo 1024 		> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpacket
		echo $burstnum	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxburst
		echo $payload	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_maxpayload
		echo "UVC Camera $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/control_interface_name
		echo "Video Streaming $uvc_index"	> /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index/streaming_interface_name

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/control/header/h
		cd functions/uvc.usb$uvc_index/control/

		ln -s header/h class/fs
		ln -s header/h class/ss
		cd /sys/kernel/config/usb_gadget/g1/

		echo 0xEF > bDeviceClass
		echo 0x02 > bDeviceSubClass
		echo 0x01 > bDeviceProtocol
		echo 0x0409 > bcdDevice
		echo 0xC0 > configs/b.1/bmAttributes
		echo 0x01 > configs/b.1/MaxPower

		if [[ "$mode" == "raw" ]]; then
			echo "=====================>config raw senosr"
			#################################example YUY2################################
			make_format_yuy2 1 1280  970  83333 333333 400000

			#################################example Z16################################
			make_format_z16  1 1280  970  83333 333333 400000
			echo -ne \\x5a\\x31\\x36\\x20\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/z16/guidFormat

		elif [[ $mode == "hdr" ]]; then
			#################################example YUY2################################
			make_format_yuy2 1  640  480 400000
			make_format_yuy2 2  320  240 400000
			make_format_yuy2 3  800  600 400000
			make_format_yuy2 4 1280  720 400000
			make_format_yuy2 5 1280  960 400000
			make_format_yuy2 6 1920 1080 400000

			#################################example MJPEG################################
			make_format_h264 1  640  480 400000
			make_format_h264 2  320  240 400000
			make_format_h264 3  800  600 400000
			make_format_h264 4 1280  720 400000
			make_format_h264 5 1280  960 400000
			make_format_h264 6 1920 1080 400000

			#################################example H265################################
			make_format_h265 1  640  480 400000
			make_format_h265 2  320  240 400000
			make_format_h265 3  800  600 400000
			make_format_h265 4 1280  720 400000
			make_format_h265 5 1280  960 400000
			make_format_h265 6 1920 1080 400000
			echo -ne \\x48\\x45\\x56\\x43\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/framebased/h265/guidFormat

			#################################example MJPEG################################
			make_format_mjpeg 1  640  480 400000
			make_format_mjpeg 2  320  240 400000
			make_format_mjpeg 3  800  600 400000
			make_format_mjpeg 4 1280  720 400000
			make_format_mjpeg 5 1280  960 400000
			make_format_mjpeg 6 1920 1080 400000

			#################################exmaple NV12################################
			make_format_nv12 1  640  480 400000
			make_format_nv12 2  320  240 400000
			make_format_nv12 3  800  600 400000
			make_format_nv12 4 1280  720 400000
			make_format_nv12 5 1280  960 400000
			make_format_nv12 6 1920 1080 400000
			echo 12 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/bBitsPerPixel
			echo -ne \\x4e\\x56\\x31\\x32\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/guidFormat
		elif [[ $mode == "lt2rt" ]]; then
			#################################example YUY2################################
			make_format_yuy2 1 1280  480 333333 400000
			make_format_yuy2 2  640  240 333333 400000
			make_format_yuy2 3 1600  600 333333 400000
			make_format_yuy2 4 2560  720 333333 400000
			make_format_yuy2 5 2560  960 333333 400000
			make_format_yuy2 6 3840 1080 333333 400000

			#################################exmaple NV12################################
			make_format_nv12 1 1280  480 333333 400000
			make_format_nv12 2  640  240 333333 400000
			make_format_nv12 3 1600  600 333333 400000
			make_format_nv12 4 2560  720 333333 400000
			make_format_nv12 5 2560  960 333333 400000
			make_format_nv12 6 3840 1080 333333 400000
			echo 12 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/bBitsPerPixel
			echo -ne \\x4e\\x56\\x31\\x32\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/guidFormat
		elif [[ $mode == "up2dn" ]]; then
			#################################example YUY2################################
			make_format_yuy2 1  640  960 333333 400000
			make_format_yuy2 2  320  480 333333 400000
			make_format_yuy2 3  800 1200 333333 400000
			make_format_yuy2 4 1280 1440 333333 400000
			make_format_yuy2 5 1280 1920 333333 400000
			make_format_yuy2 6 1920 2160 333333 400000

			#################################exmaple NV12################################
			make_format_nv12 1  640  960 333333 400000
			make_format_nv12 2  320  480 333333 400000
			make_format_nv12 3  800 1200 333333 400000
			make_format_nv12 4 1280 1440 333333 400000
			make_format_nv12 5 1280 1920 333333 400000
			make_format_nv12 6 1920 2160 333333 400000
			echo 12 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/bBitsPerPixel
			echo -ne \\x4e\\x56\\x31\\x32\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/guidFormat
		else
			#################################example YUY2################################
			make_format_yuy2 1  640  480 333333 400000
			make_format_yuy2 2  320  240 333333 400000
			make_format_yuy2 3  800  600 333333 400000
			make_format_yuy2 4 1280  720 333333 400000
			make_format_yuy2 5 1280  960 333333 400000
			make_format_yuy2 6 1920 1080 333333 400000

			#################################example MJPEG################################
			make_format_h264 1  640  480 333333 400000
			make_format_h264 2  320  240 333333 400000
			make_format_h264 3  800  600 333333 400000
			make_format_h264 4 1280  720 333333 400000
			make_format_h264 5 1280  960 333333 400000
			make_format_h264 6 1920 1080 333333 400000

			#################################example H265################################
			make_format_h265 1  640  480 333333 400000
			make_format_h265 2  320  240 333333 400000
			make_format_h265 3  800  600 333333 400000
			make_format_h265 4 1280  720 333333 400000
			make_format_h265 5 1280  960 333333 400000
			make_format_h265 6 1920 1080 333333 400000
			echo -ne \\x48\\x45\\x56\\x43\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/framebased/h265/guidFormat

			#################################example MJPEG################################
			make_format_mjpeg 1  640  480 333333 400000
			make_format_mjpeg 2  320  240 333333 400000
			make_format_mjpeg 3  800  600 333333 400000
			make_format_mjpeg 4 1280  720 333333 400000
			make_format_mjpeg 5 1280  960 333333 400000
			make_format_mjpeg 6 1920 1080 333333 400000

			#################################exmaple NV12################################
			make_format_nv12 1  640  480 333333 400000
			make_format_nv12 2  320  240 333333 400000
			make_format_nv12 3  800  600 333333 400000
			make_format_nv12 4 1280  720 333333 400000
			make_format_nv12 5 1280  960 333333 400000
			make_format_nv12 6 1920 1080 333333 400000
			echo 12 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/bBitsPerPixel
			echo -ne \\x4e\\x56\\x31\\x32\\x0\\x0\\x10\\x0\\x80\\x0\\x0\\xaa\\x0\\x38\\x9b\\x71 > functions/uvc.usb$uvc_index/streaming/uncompressed/nv12/guidFormat

			if [[ "$mode" == "4k" ]]; then
				make_format_mjpeg 7 3840 2160 333333 400000
				make_format_nv12  7 3840 2160 333333 400000
				make_format_yuy2  7 3840 2160 333333 400000
				#make_format_h264  7 3840 2160 333333 400000 #h264 encoder not support 4k
				make_format_h265  7 3840 2160 333333 400000
			fi
		fi

		cd /sys/kernel/config/usb_gadget/g1/
		mkdir functions/uvc.usb$uvc_index/streaming/header/h
		cd functions/uvc.usb$uvc_index/streaming/header/h
		if [[ "$mode" == "raw" ]]; then
			echo "=====================>config raw senosr format"
			ln -s ../../uncompressed/yuy2
			ln -s ../../uncompressed/z16
		elif [[ $mode == "lt2rt" ]] || [[ $mode == "up2dn" ]]; then
			ln -s ../../uncompressed/nv12
			ln -s ../../uncompressed/yuy2
		else
			ln -s ../../framebased/h265
			ln -s ../../framebased/h264
			ln -s ../../mjpeg/m
			ln -s ../../uncompressed/nv12
			ln -s ../../uncompressed/yuy2
		fi

		cd ../../class/fs
		ln -s ../../header/h
		cd ../../class/hs
		ln -s ../../header/h
		cd ../../class/ss
		ln -s ../../header/h

		ln -s /sys/kernel/config/usb_gadget/g1/functions/uvc.usb$uvc_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
		uvc_index=$(( $uvc_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;

	hid|hid_arto)
		echo USB_CONFIGFS: HID hid_index $hid_index func_index $func_index

		mkdir /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index

		echo 0 > /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index/protocol
		echo 512 > /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index/report_length
		if [[ $word == "hid_arto" ]]; then
			echo -ne \\x05\\x8c\\x09\\x01\\xa1\\x01\\x09\\x03\\x15\\x00\\x26\\x00\\xff\\x75\\x40\\x95\\x40\\x81\\x02\\x09\\x04\\x15\\x00\\x26\\x00\\xff\\x75\\x80\\x95\\x40\\x91\\x02\\xc0 > /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index/report_desc
		else
			echo -ne \\x05\\x8c\\x09\\x01\\xa1\\x01\\x09\\x03\\x15\\x00\\x26\\x00\\xff\\x75\\x40\\x95\\x40\\x81\\x02\\x09\\x04\\x15\\x00\\x26\\x00\\xff\\x75\\x40\\x95\\x40\\x91\\x02\\xc0 > /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index/report_desc
		fi

		ln -s /sys/kernel/config/usb_gadget/g1/functions/hid.usb$hid_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
		hid_index=$(( $hid_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;
	mass_storage)
		echo USB_CONFIGFS: MASS_STORAGE mass_storage_index $mass_storage_index func_index $func_index

		mkdir /sys/kernel/config/usb_gadget/g1/functions/mass_storage.usb$mass_storage_index
#		mkdir /tmp/pc
#		dd if=/dev/zero of=/tmp/msc.vfat.img bs=1M count=70
#		mkfs.vfat /tmp/msc.vfat.img
#		echo /tmp/msc.vfat.img > /sys/kernel/config/usb_gadget/g1/functions/mass_storage.usb$mass_storage_index/lun.0/file
#		mount -t vfat /tmp/msc.vfat.img /tmp/pc

		record_num=$(cat /fdisk.info | grep record | awk '{print $1}')
		echo /dev/mmcblk0p$record_num > /sys/kernel/config/usb_gadget/g1/functions/mass_storage.usb$mass_storage_index/lun.0/file
		ln -s /sys/kernel/config/usb_gadget/g1/functions/mass_storage.usb$mass_storage_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index

		mass_storage_index=$(( $mass_storage_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;
	serial)
		echo USB_CONFIGFS: SERIAL serial_index $serial_index func_index $func_index

		mkdir -p /sys/kernel/config/usb_gadget/g1/functions/acm.usb$serial_index
		ln -s /sys/kernel/config/usb_gadget/g1/functions/acm.usb$serial_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index

		serial_index=$(( $serial_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;
	uac1|uac1_in|uac1_out)
		echo USB_CONFIGFS: UAC uac1_index $uac1_index func_index $func_index 

		mkdir -p /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index
		echo 8 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/req_number
		if [[ $word == "uac1_in" ]]; then
			echo 0 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/c_chmask
			echo 3 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/p_chmask
		elif [[ $word == "uac1_out" ]]; then
			echo 3 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/c_chmask
			echo 0 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/p_chmask
		fi
		#echo 3 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/c_ssize
		#echo 3 > /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index/p_ssize
		ln -s /sys/kernel/config/usb_gadget/g1/functions/uac1.usb$uac1_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index

		uac1_index=$(( $uac1_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;
	adbd)
		if [[ $adbd_index == 0 ]]; then
			echo USB_CONFIGFS: ADBD adbd_index $adbd_index func_index $func_index
			cd /
			mkdir /sys/kernel/config/usb_gadget/g1/functions/ffs.adb
			ln -s /sys/kernel/config/usb_gadget/g1/functions/ffs.adb /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index
			mkdir -p /dev/usb-ffs/adb
			mount -t functionfs adb /dev/usb-ffs/adb
			cp /local/usr/bin/adbd /tmp/
			/tmp/adbd &
			while [ 1 ]; do
				if [ -e /dev/usb-ffs/adb/ep1 ] && [ -e /dev/usb-ffs/adb/ep2 ]; then
					break
				fi
				usleep 100
			done
			adbd_index=$(( $adbd_index + 1 ))
			func_index=$(( $func_index + 1 ))
		else
			echo USB_CONFIGFS: ADBD no support multi function
		fi
		;;
	sourcesink)
		echo USB_CONFIGFS: SourceSink sourcesink_index $sourcesink_index func_index $func_index

		mkdir -p /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index
		echo 1 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/isoc_interval
		echo 15 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/isoc_maxburst
		echo 2 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/isoc_mult
		echo 1 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/int_interval
		echo 15 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/int_maxburst
		echo 2 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/int_mult
		echo 8 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/bulk_qlen
		echo 8 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/iso_qlen
		echo 8 > /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index/int_qlen
		ln -s /sys/kernel/config/usb_gadget/g1/functions/SourceSink.usb$sourcesink_index /sys/kernel/config/usb_gadget/g1/configs/b.1/f$func_index 

		sourcesink_index=$(( $sourcesink_index + 1 ))
		func_index=$(( $func_index + 1 ))
		;;
	*)
		echo USB_CONFIGFS: NONE
		echo Usage: gUSB_GADGET_CONFIGFS=rndis+uvc
		exit 1
		;;
	esac
done

ln -s /sys/kernel/config/usb_gadget/g1/configs/b.1 /sys/kernel/config/usb_gadget/g1/os_desc/b.1

echo "$gUSB_GADGET_CONFIGFS" > /sys/kernel/config/usb_gadget/g1/configs/b.1/strings/0x409/configuration
if [[ "$3" == "cdns3" ]]; then
	echo "60300000.cadence_usb" > /sys/kernel/config/usb_gadget/g1/UDC
else
	echo "60500000.dwc3" > /sys/kernel/config/usb_gadget/g1/UDC
fi

func=$( echo $gUSB_GADGET_CONFIGFS | grep rndis)
if [[ "$func" != "" ]]; then
	if [[ "$2" == "sink" ]]; then
		ifconfig usb0 172.16.3.100 up
	else
		ifconfig usb0 192.168.3.100 up
	fi
fi

func=$( echo $gUSB_GADGET_CONFIGFS | grep serial)
if [[ "$func" != "" ]]; then
	echo "ttyGS0::askfirst:-/bin/sh" >> /etc/inittab
	kill -HUP 1
	#passwd root -d ""
	#su root -c "sbin/getty -L -w /dev/ttyGS0 115200 vt100 &"
fi
usleep 100000
echo USB_CONFIGFS: finished ...
