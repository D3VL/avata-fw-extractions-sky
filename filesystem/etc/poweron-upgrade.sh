#!/bin/sh

#set -x
imgfile="artosyn-upgrade-sirius-0.0.0.1.img"
flag="/local/upgrade-flag"
# image include the full path if the image is found
image=

# check image file in directory /media
function haveimg()
{
	for i in `ls /media`
	do
		upandir=/media/$i
		if [ -d $upandir ]; then
			for j in `ls $upandir`
			do
				if [ -f $upandir/$j ]; then
					if [ $j == $imgfile ]; then
						image=$upandir/$imgfile
						break
					fi
				fi
			done
		fi
		if [ ! -z $image ]; then
			break
		fi
	done
}

# 10s for scanning the image file
for i in `seq 10`
do
	haveimg
	if [ ! -z $image ]; then
		break
	else
		sleep 1
	fi
done

if [ -z $image ]; then
	echo "the image file is not found, startup normally"
	/etc/led-blink.sh 3 84 &
	exit 0
else
	echo "the image file: $image"
	# since sdk32, the option m is supportted, and since sdk31, s is supportted
	# get the image version
	imageversion=`artosyn_upgrade -sm $image | grep "SDK Version" | cut -b 14-`
	# get current version
	curversion=`cat /etc/sdk.version | cut -d = -f 2`
	if [ $imageversion != $curversion ]; then
		echo "start upgrade"
		# reboot mode, normal system call it
		if [ ! -f $flag ]; then
			touch $flag
			if [ $? != 0 ]; then
				echo "creat file failed"
				exit 1
			fi
			sync
			artosyn_upgrade -c
		else
			rm $flag
			# led blink, frequence is 1 before upgrade finish
			/etc/led-blink.sh 1 84 &
			# do really upgrade here, and led blink
			artosyn_upgrade -mvr $image
			# led blink, frequence is 5 after upgrade finish
			if [ $? == 0 ]; then
				/etc/led-blink.sh 3 84 &
			else
				echo "upgrade failed"
				/etc/led-blink.sh 10 84 &
				exit 1
			fi
		fi

	else
		echo "image version is the same with current version, startup normally"
		/etc/led-blink.sh 3 84 &
		exit 0
	fi
fi

