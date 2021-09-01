# ISO Builder

## What does this script do? 

This script lets you create a completely automated Ubuntu Server installation CD (default:18.04.2 64 bit) that you can boot on any PC and have a working server in minutes without ever touching a keyboard.

## How does it do it?

Fuses Ubuntu iso with a [KickStart](https://pykickstart.readthedocs.io/en/latest/) file, configures and creates a new ISO file.

## How do I run it?
If you are using Ubuntu, plese install the required components using apt:
sudo apt-get update -y
sudo apt-get install mkisofs coreutils -y

Change directory to ISO and update permissions for the sh scripts.
chmod +x ./ubuntu-iso-builder.sh
chmod +x ./ubuntu-iso-builder-gpu.sh

Run one of the scripts from the ISO directory:
./ubuntu-iso-builder.sh - to build an ISO image with settings described in the ks.cfg Kickstart file.
./ubuntu-iso-builder-gpu.sh - to build an ISO image with settings described in the ks-gpu.cfg Kickstart file. The file contains the same settings as ks.cfg but in addition it contains steps for installation of Nvidia drivers and runtime components.

Upon completion, the script will create a new ISO image in the ISO directory with the prefix autoinstall-ubuntu -*.
### Default settings

Default username with administrative permissions is 'zicons'.
Default password is 'phaoT2dut&'.