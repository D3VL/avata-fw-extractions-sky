#!/bin/bash
uvc_num=`ps | grep uvc_service | wc -l`                     
while [ $uvc_num -ne 1 ]                           
do                                              
	killall uvc_service_n4o               
	killall uvc_service2                  
	killall uvc_service                                 
        sleep 1              
	uvc_num=`ps | grep uvc_service | wc -l`                     
done
umount /tmp/pc   
cd /sys/kernel/config/usb_gadget/g1                
echo '' > UDC                                      
find configs -type l -exec rm -v {} \;             
find configs -name 'strings' -exec rmdir -v {}/0x409 \;
ls -d configs/* | xargs rmdir -v                       
ls -d strings/* | xargs rmdir -v                       
ls -d functions/* | xargs rmdir -v                     
cd ..                                                  
rmdir -v g1                                            
rm -rf g1                                              
rm -rf g1 
