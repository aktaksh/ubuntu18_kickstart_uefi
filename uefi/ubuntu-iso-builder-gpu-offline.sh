#WARNING. This configuration shoudn't be used, it is only a backup.

#!/bin/bash
# SRC control : Ankeit Taksh
echo "============================================================"
echo "RUNs on Ubuntu only as ROOT user, Enter to Agree & Proceed: "
echo "============================================================"

read x
# edit these 3 variables if you want to try another distro. create an md5sum
# file with something like 
#   md5sum $ISO > $ISO.MD5SUM

ISO=ubuntu-18.04.2-server-amd64.iso
OUTPUT=autoinstall-gpu-ubuntu-18.04.2-server-amd64.iso
URL=http://releases.ubuntu.com/18.04.2/ubuntu-18.04.2-server-amd64.iso

MOUNT=iso-mount-dir
WORK=iso-work-dir
# Install wget
apt update && apt install wget -y
# if we don't have iso or it doesnt' match md5sum, fetch it
if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
then
    rm -f $ISO
	wget $URL
    # Check for MD5 to verify the image download
    if [ ! -f $ISO ]  || !  md5sum -c $ISO.MD5SUM 
    then
        echo "Unable to download ISO, chck your network or FW"
        exit 1
    fi
fi

# Clean up and run again
umount $MOUNT
rm -rf $MOUNT $WORK

# make mount point, mount it with sudo, copy over contents because ISO's
# can only be mounted readonly
mkdir -p $MOUNT $WORK
sudo mount -o ro,loop $ISO $MOUNT
cp -rT $MOUNT $WORK
chmod -R a+w $WORK

# copy files over to image
cp ks-gpu-offline.cfg $WORK/ks.cfg
cp txt.cfg $WORK/isolinux/
cp isolinux.cfg $WORK/isolinux/
#Downlaoding and copying packages to the ISO for offline installation
wget --no-clobber --input-file=./packages/chromium/chromium-browser.list --directory-prefix=./packages/chromium/
wget --no-clobber --input-file=./packages/nvidia/nvidia-driver-465.list --directory-prefix=./packages/nvidia/
wget --no-clobber --input-file=./packages/nvidia-runtime/nvidia-container-runtime.list --directory-prefix=./packages/nvidia-runtime/
mkdir $WORK/packages
cp -R ./packages/* $WORK/packages/

# magic mkiso incantation
mkisofs -D -r -V “AUTOINSTALL” -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o $OUTPUT $WORK
echo "========================================================================"
echo "$OUTPUT is available at current location . Burn it to USB using rufus"
echo "========================================================================"
# clean up after ourselves
sudo umount $MOUNT
rm -rf $MOUNT $WORK
