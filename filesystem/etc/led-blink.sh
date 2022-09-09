#!/bin/sh

# gpiopath="/sys/class/gpio"
# 
# if [ $# != 2 ]; then
# 	echo "usage: $0 freq pin"
# 	echo "example: $0 5 10 ----- freq is 5, pin is 10"
# 	exit
# fi
# 
# # export pin
# if [ ! -e $gpiopath/gpio$2 ]; then
# 	echo $2 > /sys/class/gpio/export
# fi
# 
# # set output mode
# echo out > $gpiopath/gpio$2/direction
# 
# while true
# do
# 	echo 1 > $gpiopath/gpio$2/value
# 	sleep $1
# 	echo 0 > $gpiopath/gpio$2/value
# 	sleep $1
# done

