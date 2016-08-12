#!/bin/sh

echo "Digital Devices drivers building..."
make -j4

echo "Digital Devices drivers installing..."
sudo make install
sudo depmod -a

echo "Digital Devices drivers installation done"
echo "You need to reboot..."
