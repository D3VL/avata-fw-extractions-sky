#!/bin/sh

# check video device and start the dsps

#/etc/init.d/start_dsp.sh $ceva0_part $ceva1_part $ceva2_part $ceva3_part \
# /dev/video_yuv-1 /local/usr/bin/std_ssd_config.ini &

echo start isp tool dsp $1 $2 $3 $4 $5 $6

export PATH="/bin:/sbin:/usr/bin:/usr/sbin:/local/usr/bin/:."
export LD_LIBRARY_PATH="/lib:/usr/lib:/local/usr/lib:"

if [ $1 != /dev/null ]; then
	echo booting dsp $1
	ar_dsp_bootup 0 $1
fi;

if [ $2 != /dev/null ]; then
	echo booting dsp $2
	ar_dsp_bootup 1 $2
fi;

if [ $3 != /dev/null ]; then
	echo booting dsp $3
	ar_dsp_bootup 2 $3
fi

if [ $4 != /dev/null ]; then
	echo booting dsp $4
	ar_dsp_bootup 3 $4
fi

while [ 1 ]; do
    if [ -e $5 ]; then
        if [ -e "/local/usr/bin/ar_dsp_alg" ]; then
			/local/usr/bin/ar_dsp_alg $6 $5 &
        fi
        break;
    fi
    sleep 1
done

# print dsp log into system log
if [ -e "local/usr/bin/logd" ]; then
	if [ -e "local/usr/bin/dump_dspmsg" ]; then
		dump_dspmsg -r &
	else
		echo "local/usr/bin/dump_dspmsg not exist!"
	fi
fi

exit



