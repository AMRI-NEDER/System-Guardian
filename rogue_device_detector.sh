#!/bin/bash
mkdir -p logs
arp -a > logs/connected_devices.log
echo "connected devices are :"
cat logs/connected_devices.log
ROGUE_MAC="aa:bb:cc:dd:ee:ff"

if grep -iq "$ROGUE_MAC" logs/connected_devices.log; then
echo "" 
echo "Rogue device detected!"
./alert.sh " !!! Rogue device detected on network!!!"
else 
echo ""
echo "No rogue detected"
fi
