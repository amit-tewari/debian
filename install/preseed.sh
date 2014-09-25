#!/bin/bash
clear;
function get_input {
echo 'This script generates a preseed file for Debian Wheezy'
echo 'and syslinux.cfg used by unetbootin created USB installer' 
echo 'Please input...'
echo 
read -p "Hostname  : " HOSTNAME
read -p "Full Name : " USERFULLNAME
read -p "Username  : " USERNAME

while [ -z ${USERPASS} ] || [ "${USERPASS}" != "${USERPASS1}" ] ; do
read -s -p "Password for user $USERNAME : " USERPASS
echo; read -s -p "Password for user $USERNAME ... again : " USERPASS1
echo 
done 


while [ -z ${ROOTPASS} ] || [ "${ROOTPASS}" != "${ROOTPASS1}" ] ; do
read -s -p "Root Password : " ROOTPASS
echo; read -s -p "Root Password... again : " ROOTPASS1
echo
done
}

function sample_input {
HOSTNAME=hname
USERFULLNAME="User Name"
USERNAME=uname
USERPASS=upass
ROOTPASS=rpass
}

function generate_preseed_file {
if [ ! -f wheezy-preseed.cfg ]; then 
	echo template preseed file not found;
fi
sed -e "s/HOSTNAME/${HOSTNAME}/" \
	-e "s/USERFULLNAME/${USERFULLNAME}/" \
	-e "s/USERNAME/${USERNAME}/" \
	-e "s/USERPASS/${USERPASS}/" \
	-e "s/ROOTPASS/${ROOTPASS}/" \
	wheezy-preseed.cfg > /tmp/preseed.cfg
	#wheezy-preseed.cfg | grep 'hname\|User Name\|uname\|upass\|rpass' 
	CHECKSUM=$(md5sum /tmp/preseed.cfg | cut -d' ' -f1)
}

function generate_syslinux_cfg_file {
if [ ! -f wheezy-syslinux.cfg ]; then 
	echo template syslinux file not found;
fi
sed -e "s/CHECKSUM/${CHECKSUM}/" wheezy-syslinux.cfg > /tmp/syslinux.cfg
#sed -e "s/CHECKSUM/${CHECKSUM}/" wheezy-syslinux.cfg | grep ${CHECKSUM}
}

function echo_input {
echo
echo "host name        : $HOSTNAME"
echo "Full user name   : $USERFULLNAME"
echo "User/ login name : $USERNAME"
echo "user password    : $USERPASS"
echo "root password    : $ROOTPASS"
echo "preseed file md5 : $CHECKSUM"
echo
echo "preseed file is copied at /tmp/preseed.cfg"
echo "syslinux file is copied at /tmp/syslinux.cfg"
}

# Main work starts here
#sample_input
get_input
generate_preseed_file
generate_syslinux_cfg_file
echo_input
echo

