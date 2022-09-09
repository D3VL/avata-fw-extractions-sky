echo start net test
echo "=========="`date`"==========" > /tmp/nettest.log

#test size 56(84) bytes 1000 times
echo "test size 56(84) bytes 1000 times" >> /tmp/nettest.log
test_ar_iputils -f -q -c 1000 $1 >> /tmp/nettest.log

echo "=====================================" >> /tmp/nettest.log

#test size 1500 bytes 1000 times
echo "test size 1500 bytes 1000 times" >> /tmp/nettest.log
test_ar_iputils -f -q -c 1000 -s 1500 $1 >> /tmp/nettest.log

echo complete net test, please see /tmp/nettest.log for detail.
