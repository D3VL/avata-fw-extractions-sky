#!/bin/sh

#set -x

#$1: the application name, $2: signal if exsit, for example, kill_apps "app" -15
function kill_apps()
{
	pidof $1 	1>/dev/null 2>&1
	#process is exist
	if [ $? -eq 0 ]; then
		for i in `seq 1 3`
		do
			killall -q $2 $1
			sleep 2
			pidof $1 	1>/dev/null 2>&1
			#process is not exist
			if [ $? -ne 0 ]; then
				return;
			fi
		done

		echo "kill $1 failed"
		exit 1
	fi
}

# clean system flag file, exsit means clean system, otherwise normal system
flagfile="/usrdata/sirius-clean-system-flag"

mountpoint -q "/usrdata"
if [ $? != 0 ]; then
	echo "/usrdata is not a mountpoint, cannot enter clean system"
	exit 1
fi

if [ ! -e $flagfile ]; then
	touch $flagfile
	if [ $? != 0 ]; then
		echo "create $flagfile failed, cannot enter clean system"
		exit 1
	fi
fi

sync
#FIXME evb is not supported
if [ -e "/local/usr/bin/ar_wdt_service" ]; then

	if [ -e "/mod/da9062_wdt.ko" ]; then
		insmod /mod/da9062_wdt.ko
	fi

	kill_apps "ar_wdt_service"
	/local/usr/bin/ar_wdt_service -t 0 1>/dev/null 2>&1
	if [ $? != 0 ]; then
		echo "reboot system failed, you should reboot by yourself"
		exit 1
	fi
else
	echo "ar_wdt_service is not exsit, can not reboot the system,"
	echo "you should reboot by yourself"
	exit 1
fi

exit 0

##################################################################################
#====================the below is test, never execute============================#
##################################################################################
if [ -e "/local/usr/bin/fw_setenv" ]; then
	/local/usr/bin/fw_setenv sirius_system clean
	if [ $? == 0 ]; then
		#FIXME evb is not supported
		if [ -e "/local/usr/bin/ar_wdt_service" ]; then
			/local/usr/bin/ar_wdt_service -t 0 1>/dev/null 2>&1
			if [ $? != 0 ]; then
				echo "reboot system failed, you should reboot by yourself"
				exit 1
			fi
		else
			echo "ar_wdt_service is not exsit, can not reboot the system,"
			echo "you should reboot by yourself"
			exit 1
		fi
	else
		echo "fw_setenv sirius_system clean failed"
		exit 1
	fi
else
	echo "fw_setenv is not exsit, can not enter clean system"
	exit 1
fi

