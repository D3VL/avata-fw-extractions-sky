#!/bin/sh

i=0
#a="  rtos:"
#c=`uptime`

#####adc temp enable####### 
let tmp=`devmem 0x60632018`      
let mask=0xfffffffe              
let val=$(($tmp&$mask))          
devmem 0x60632018 32 $val  

#####select ad2############
devmem 0x60632038 32 0x02

while true
do

devmem 0x60632000 32 0x1
let temp=`devmem 0x60632910`
let val=$(($temp*4825-777000))

let low=`devmem 0x60632160`
let high=`devmem 0x60632164`
let mask=0x03
let high=$((high&mask))
let volt=$((high*256+low))
let volt=$((volt*1800/1024))


echo `date` temp:$val raw:$temp volt:$volt

#echo $c$a$((16$b))

sleep 1

done
