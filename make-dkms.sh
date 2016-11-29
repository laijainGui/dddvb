#!/bin/bash

VER="0.9.28"
rm -f dkms.conf

echo -e 'MAKE="make all KDIR=/lib/modules/${kernelver}/build"' >> dkms.conf;
echo -e 'CLEAN="make clean"' >> dkms.conf;
echo -e 'PACKAGE_NAME=dddvb' >> dkms.conf;
echo -e 'PACKAGE_VERSION='$VER >> dkms.conf;
echo -e 'AUTOINSTALL=yes' >> dkms.conf;

sudo make clean
sudo make -j4 install

counter=0;
for mod in $(find . -name "*.ko");
do echo -e 'BUILT_MODULE_NAME['$counter']='$(basename $mod .ko)  >> dkms.conf;
echo -e 'BUILT_MODULE_LOCATION['$counter']='$(dirname $mod)'/' >> dkms.conf;
echo -e 'DEST_MODULE_LOCATION['$counter']=/extra/dddvb/' >> dkms.conf; let counter++;
done

sudo rm -r -f /lib/modules/$(uname -r)/extra
sudo make clean

sudo rm -rf /usr/src/dddvb-$VER
sudo mkdir /usr/src/dddvb-$VER
sudo cp -r ddbridge ddip dvb-core frontends include Kbuild Makefile CHANGELOG dkms.conf /usr/src/dddvb-$VER
sudo dkms remove -m dddvb/$VER --all
sudo dkms add -m dddvb/$VER
sudo dkms build -m dddvb/$VER
sudo dkms mkdeb -m dddvb/$VER

rm -f /var/lib/dkms/dddvb/$VER/deb/dddvb-dkms_$VER_all.deb
cp /var/lib/dkms/dddvb/$VER/deb/dddvb-dkms_"$VER"_all.deb .

sudo dkms remove -m dddvb/$VER --all
