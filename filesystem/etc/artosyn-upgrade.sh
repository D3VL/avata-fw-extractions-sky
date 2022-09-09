#! /bin/ash

#set -x
if [ $# != 2 ] && [ $# != 1 ]; then
	echo "Usage: $0 partition_name image_file, partition_name can be ignored"
	echo "example: $0 a7_rtos a7_rtos.nonsec.img"
	echo "         $0 a7_rtos.nonsec.img ----- get partition_name by image file name"
	echo ""
	echo "            *********  attentions  *********                     "
	echo "env and spl partition is not supported now, maybe support later"
	echo "if flash_part=1 in .ini file, image_file is the path value +.ubi,"
	echo "otherwise image_file is the path value"
	echo "                                     "
	echo "example: the information in .ini file"
	echo "                                     "
	echo "[partition10]"
	echo "name=a7_rtos"
	echo "path=./output/image/a7_rtos.nonsec.img"
	echo "size=0x600000"
	echo "upgrade=y"
	echo "flash_part=1"
	echo "                                      "
	echo "so image_file shoule be ./output/image/a7_rtos.nonsec.img.ubi"
	exit 1
fi

#kill apps before upgrade userapp, usr_data, factory
for part in "userapp" "usr_data" "factory"
do
	if [ $1 == $part ]; then
		/etc/ota-prepare.sh
		if [ $? != 0 ]; then
			exit 1
		fi
	fi
done

echo "upgrade $1 ..."
function upgrade() {
	echo "flashtype: "$flashtype

	if [ $flashtype == nor ] || [ $flashtype == mcp ]; then
		upgrade_part=`cat /proc/mtd | grep -r $1 -m 1 | cut -d : -f 1` 1>/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "upgrade $1 failed"
			exit
		fi
		upgrade_part_type=`cat /sys/class/mtd/$upgrade_part/type` 1>/dev/null 2>&1
		if [ $? != 0 ]; then
			echo "upgrade $1 failed"
			exit
		fi

		#do not care weather mcp or nor, but nand or nor
		if [ $upgrade_part_type == nor ]; then
			echo "part_type: nor"

			#erase the whole partition
			/etc/flash_erase /dev/$upgrade_part 0 0
			dd if=$2 of=/dev/$upgrade_part
			if [ $? != 0 ]; then
				echo "upgrade $1 failed"
				exit
			fi

			sync
		elif [ $upgrade_part_type == nand ]; then
			echo "part_type: nand"

			#ubidetach before ubiformat, up to ubi10(factory)now
			for i in `seq 11`
			do
				mtd_num=`cat /sys/class/ubi/ubi$i/mtd_num` 1>/dev/null 2>&1
				if [ mtd$mtd_num == $upgrade_part ]; then
					ubidetach -d $i /dev/ubi_ctrl
					if [ $? != 0 ]; then
						echo "ubidetach ubi$i failed, upgrade failed"
						exit 1
					fi

					cat /proc/cmdline | grep "($1)ro," 1>/dev/null 2>&1
					# read only mtdpart
					if [ $? == 0 ]; then
						echo "$1 is read only"

						# find nand master device
						nand_master=`cat /proc/mtd | grep "art_nand" | cut -d : -f 1`

						# get mtdpart range
						partstart=`dmesg | grep " : \"$1\"$" | sed 's/\[.*\]//g' | cut -d - -f 1`
						partsize=`cat /proc/mtd | grep "00020000 \"$1\"" | cut -d " " -f 2`

						# delete mtdpart
						/etc/mtdpart del /dev/$nand_master $mtd_num
						if [ $? != 0 ]; then
							echo "delete mtdpart: $1 failed"
							exit 1
						fi

						# add mtdpart rw
						/etc/mtdpart add /dev/$nand_master $1 $partstart 0x$partsize
						if [ $? != 0 ]; then
							echo "add mtdpart: $1 failed"
							exit 1
						fi
					fi
					/etc/ubiformat /dev/$upgrade_part -f $2
					if [ $? != 0 ]; then
						echo "ubiformat $1 failed, upgrade failed"
						exit 1
					fi
					break
				fi
			done

			#ubidetach allready, upgrade direactly
			if [ $i == 11 ]; then
				/etc/ubiformat /dev/$upgrade_part -f $2
				if [ $? != 0 ]; then
					echo "ubiformat $1 failed, upgrade failed"
					exit 1
				fi
			fi

			sync
		fi
	elif [ $flashtype == mmc1 ] || [ $flashtype == mmc0 ]; then
		if [ $flashtype == mmc0 ]; then
			mmc_prefix=mmcblk0p
		else
			mmc_prefix=mmcblk1p
		fi

		upgrade_part=`cat /fdisk.info | grep -r $1 -m 1 | sed 's/^[ \t]*//g' | cut -d " " -f 1` 1>/dev/null 2>&1
		if [ -z "$upgrade_part" ]; then upgrade_part=null;
		else
			upgrade_part="$mmc_prefix"$upgrade_part
			dd if=$2 of=/dev/$upgrade_part conv=fsync
			if [ $? != 0 ]; then
				echo "upgrade $1 failed"
				exit 1
			fi
		fi

		sync
	fi
}

function get_flashtype() {

	#fixme: bootmode can get from uboot.
	bootmode=`devmem 0x60633100`

	case $bootmode in
	0x00000002 | 0x00000003)
		#if bootmod is emmc, wait and check emmc partition
		echo "waiting emmc or sd device done"
		while [ true ]
		do
			if [ -e "/dev/mmcblk0boot0" ]; then
				flashtype=mmc0
				break
			elif [ -e "/dev/mmcblk1boot0" ]; then
				flashtype=mmc1
				break
			fi
		done
		;;
	*)
		#if bootmode is qspi nor, check the /dev/mtd to know device is qspi nor or mcp
		cat /proc/mtd | grep -r "art_nand" -m 1 1>/dev/null 2>&1
		if [ $? == 0 ]; then
			flashtype=mcp
		else
			flashtype=nor
		fi
		;;
	esac
}

#call function to get flashtype
get_flashtype

if [ $# == 2 ]; then
	upgrade $1 $2
else
	# get file name
	file=$(basename $1)
	case $file in
	optee.img)
		upgrade "optee0" $1
		upgrade "optee1" $1
		;;
	uboot.nonsec.img)
		upgrade "uboot0" $1
		upgrade "uboot1" $1
		;;
	kernel.img)
		upgrade "kernel" $1
		;;
	artosyn-board.dtb)
		upgrade "dtb" $1
		;;
	all_rootfs.squashfs | all_rootfs.ext4)
		upgrade "userapp" $1
		;;
	ceva0.nonsec.img)
		upgrade "ceva0" $1
		;;
	ceva1.nonsec.img)
		upgrade "ceva1" $1
		;;
	ceva2.nonsec.img)
		upgrade "ceva2" $1
		;;
	ceva3.nonsec.img)
		upgrade "ceva3" $1
		;;
	a7_rtos.nonsec.img)
		upgrade "a7_rtos" $1
		;;
	usr_data.ext4 | usr_data.ubifs | usr_data.jffs2)
		upgrade "usr_data" $1
		;;
	*)
		echo "unknown image file name pattern, you need give partition_name
		parameter"
		exit 1
		;;
	esac
fi

echo "upgrade $1 complete, please reset the board..."
