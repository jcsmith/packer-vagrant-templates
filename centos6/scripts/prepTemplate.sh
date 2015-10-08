#!/usr/bin/env sh

get_distro() {
	if [ -f '/etc/redhat-release' ]; then
		echo "RHEL"
	elif [ -f '/etc/debian_version' ]; then
		echo "DEBIAN"
	else
		echo "Unknown"
	fi
}

get_lsb_distro() {
	LSB_DISTRO=$(/usr/bin/lsb_release -i | awk '{print $NF }')
	echo "$LSB_DISTRO"
}

RHEL_clean_pkg_cache() {
	/usr/bin/yum clean all
}

DEBIAN_clean_pkg_cache() {
	/usr/bin/apt-get clean
}

GENERIC_rotate_logs() {
	echo "rotating logs"
	/usr/sbin/logrotate -f /etc/logrotate.conf
}

GENERIC_remove_persestient_device_rules() {
	/bin/rm -f /etc/udev/rules.d/*-net.rules
}

RHEL_remove_template_MAC_UUID() {
	/bin/sed -i '/^\(HWADDR\|UUID\)=/d' /etc/sysconfig/network-scripts/ifcfg-eth*
}

GENERIC_clean_tmp() {
	/bin/rm -rf /tmp/*
	/bin/rm -rf /var/tmp/*
}

GENERIC_remove_SSH_host_keys() {
	/bin/rm -f /etc/ssh/*key*
}

GENERIC_remove_shell_history() {
	/bin/rm -f /home/*/.bash_history
	unset HISTFILE
}



#first lets make sure we are root, exit if we are not.
if [ "$( id -u)" != 0 ]; then
	echo "You must execute this script as root.  Try sudo $0"
	exit 1
fi

DISTRO="$(get_distro)"

#1. clean package caches
"$DISTRO"_clean_pkg_cache

#2. rotate logs
GENERIC_rotate_logs

#3. remove persistent device rules
GENERIC_remove_persestient_device_rules

#4. remove traces of template MAC and UUID
"$DISTRO"_remove_template_MAC_UUID

#5. clean /tmp and /var/tmp
GENERIC_clean_tmp

#6. remove template ssh host keys
GENERIC_remove_SSH_host_keys

#7. remove shell history
GENERIC_remove_shell_history

