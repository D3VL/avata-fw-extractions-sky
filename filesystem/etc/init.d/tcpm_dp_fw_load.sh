#!/bin/sh

echo "load tcpm dp firmware"
exit 0
#if [ ! -d "/lib/firmware" ]; then
#    mkdir /lib/firmware
#fi

if [ -e "/local/factory/dp/tcpc_iram0.bin" ]; then
    echo 1 > /sys/class/firmware/tcpc_iram0.bin/loading
    cat /local/factory/dp/tcpc_iram0.bin > /sys/class/firmware/tcpc_iram0.bin/data
    echo 0 > /sys/class/firmware/tcpc_iram0.bin/loading

#    cp /local/usr/bin/tcpc_iram0.bin /lib/firmware/ &
fi


if [ -e "/local/factory/dp/tcpc_dram0.bin" ]; then
    echo 1 > /sys/class/firmware/tcpc_dram0.bin/loading
    cat /local/factory/dp/tcpc_dram0.bin > /sys/class/firmware/tcpc_dram0.bin/data
    echo 0 > /sys/class/firmware/tcpc_dram0.bin/loading
    
#    cp /local/usr/bin/tcpc_dram0.bin /lib/firmware/ &
fi


if [ -e "/local/factory/dp/dp_iram0.bin" ] && [ -e "/sys/class/firmware/dp_iram0.bin/loading" ]; then
    echo 1 > /sys/class/firmware/dp_iram0.bin/loading
    cat /local/factory/dp/dp_iram0.bin > /sys/class/firmware/dp_iram0.bin/data
    echo 0 > /sys/class/firmware/dp_iram0.bin/loading

#    cp /local/usr/bin/tcpc_iram0.bin /lib/firmware/ &
fi


if [ -e "/local/factory/dp/dp_dram0.bin" ] && [ -e "/sys/class/firmware/dp_dram0.bin/loading" ]; then
    echo 1 > /sys/class/firmware/dp_dram0.bin/loading
    cat /local/factory/dp/dp_dram0.bin > /sys/class/firmware/dp_dram0.bin/data
    echo 0 > /sys/class/firmware/dp_dram0.bin/loading
    
#    cp /local/usr/bin/tcpc_dram0.bin /lib/firmware/ &
fi
