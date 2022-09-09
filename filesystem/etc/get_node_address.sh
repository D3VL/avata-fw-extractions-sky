#! /bin/sh
NODE_NAME=""
NODE_BASE=""

for i in /sys/firmware/devicetree/base/reserved-memory/*@* ;do
     # Ignore node (if any).
     [ ! -d "$i" ] && continue

     NODE_NAME=`echo "$i" | cut -d '/' -f 7 | cut -d '@' -f 1`
     NODE_BASE=`echo "$i" | cut -d '@' -f 2`
    
     if [ "${NODE_NAME}" = "$1" ]; then
	echo $NODE_BASE
	exit 0
     fi
    
done

exit 0



