#!/bin/sh

PATH=/sbin:/bin:/usr/sbin:/usr/bin

BOOT_DISK="/dev/mmcblk0"

ROOT_DEV=""
ROOT_MNT="/mnt/root"
ROOT_MNT_OPT="ro,relatime"

ETC_MNT="/etc"
ETC_LOWERDIR="${ROOT_MNT}/etc"
ETC_UPPERDIR="${ROOT_MNT}/var/volatile/etc"
ETC_WORKDIR="${ROOT_MNT}/var/volatile/.etc-work"
ETC_MNT_OPT="rw,relatime,lowerdir=${ETC_LOWERDIR},upperdir=${ETC_UPPERDIR},workdir=${ETC_WORKDIR}"
ETC_MACHINE_ID_MNT_OPT="bind"
HOSTNAME_MNT_OPT="bind"

LOG_MNT="/var/log"
LOG_MNT_OPT="rw,noatime,nodiratime,commit=60,data=ordered"

DATA_MNT="/data"
DATA_MNT_OPT="defaults,rw,autodefrag,space_cache=v2"

MMC_RESIZED="False"

# init
INIT="/sbin/init"

do_mount_fs() {
	grep -q "$1" /proc/filesystems || return
	test -d "$2" || mkdir -p "$2"
	mount -t "$1" "$1" "$2"
}

do_mknod() {
	test -e "$1" || mknod "$1" "$2" "$3" "$4"
}

start_watchdog() {
	echo "Starting watchdog..."
	/sbin/watchdog -f -F -X 15 &
	WATCHDOG_PID=$!
}

cleanup() {
	echo "Stopping watchdog..."
	if [ -n "$WATCHDOG_PID" ]; then
		kill "$WATCHDOG_PID" 2>/dev/null
		wait "$WATCHDOG_PID" 2>/dev/null
	fi
}
trap cleanup EXIT

error_exit() {
	echo "$1 - Reboot, press any key to execute shell"

	mountpoint -q ${ROOT_MNT}${LOG_MNT} && umount ${ROOT_MNT}${LOG_MNT}
	mountpoint -q ${ROOT_MNT}${DATA_MNT} && umount ${ROOT_MNT}${DATA_MNT}
	mountpoint -q ${ROOT_MNT} && umount ${ROOT_MNT}

	read -t 10 -n 1 key
	if [ $? -eq 0 ]; then
		#[ -e /dev/watchdog ] && while true; do : > /dev/watchdog; sleep 5; done &
		cleanup
		exec /bin/sh
	fi

	# Reboot
	reboot -f
}

get_device_by_label() {
	local label="$1"

	dev=$(blkid | grep -i -w "LABEL=\"$label\"" | cut -d: -f1)

	if [ -z "${dev}" ]; then
		error_exit "Could not find device labeled '${label}'"
	fi

	echo "Found device:${dev} label:${label}"
	DEVICE_RESULT="${dev}"
}

parse_cmdline() {
	# Parse kernel cmdline to extract base device path
	CMDLINE="$(cat /proc/cmdline)"

	for c in ${CMDLINE}; do
		if [ "${c:0:5}" == "root=" ]; then
			ROOT_DEV="${c:5}"
		fi
	done

	[ -z "${ROOT_DEV}" ] && error_exit "Unable to get root device."
}

# Wait 5 seconds unless device exist
wait_for_dev() {
	local WAIT_CNT=3
	local DEVICE="${1}"

	while [ `stat "${DEVICE}" 2>/dev/null 1>&2 ; echo $?` -ne 0 -a ${WAIT_CNT} -gt 0 ]; do
		echo "Waiting for ${DEVICE}..."
		sleep 2
		WAIT_CNT=`expr $WAIT_CNT - 1`
	done

	return ${WAIT_CNT}
}

check_and_fix_gpt_table() {
	/usr/sbin/sgdisk -v ${BOOT_DISK} | /bin/grep -zqoP "Problem: The secondary header's self-pointer indicates that it doesn't reside\\nat the end of the disk"

	if [ $? -eq 0 ]; then
		echo "Found invalid secondary GPT header, trying to fix"
		/usr/sbin/sgdisk -e ${BOOT_DISK}
	fi
}

check_ext4_fs() {
	local part="$1"
	e2fsck -f -y ${part} || echo "File system check of volume:${part} ${RED}FAILED${NC}"
}

resize_ext4_fs() {
	local part="$1"

	check_ext4_fs ${part}
	resize2fs -f ${part} || error_exit "Unable to resize ${part}"
	check_ext4_fs ${part}
}

get_partition_number_from_device() {
	echo "$1" | sed -n 's/.*[a-z]p\?\([0-9]\+\)$/\1/p'
}

check_disk_resized() {
	DISK_END=$(parted -sm ${BOOT_DISK} unit kB print | grep "^${BOOT_DISK}" | cut -d: -f2 | sed 's/kB//')
	LAST_END=$(parted -sm ${BOOT_DISK} unit kB print | grep -E '^[0-9]+:' | tail -n1 | cut -d: -f3 | sed 's/kB//')

	THRESHOLD=1024

	if [ "$((DISK_END - LAST_END))" -le "$THRESHOLD" ]; then
		MMC_RESIZED="True"
	 fi
}

mkdir -p /proc
mount -t proc proc /proc

# mount temporary filesystems
do_mount_fs sysfs /sys
do_mount_fs debugfs /sys/kernel/debug
do_mount_fs devtmpfs /dev
do_mount_fs devpts /dev/pts
do_mount_fs tmpfs /dev/shm

mkdir -p /run
mkdir -p /var/run

do_mknod /dev/console c 5 1
do_mknod /dev/null c 1 3
do_mknod /dev/zero c 1 5

echo "Starting Initramfs..."

start_watchdog

parse_cmdline
wait_for_dev ${BOOT_DISK} && error_exit "Device ${BOOT_DISK} not exist, restarting"

check_disk_resized

[ "$MMC_RESIZED" == "False" ] && echo "Disk not resized"

if [ "$(parted -sm ${BOOT_DISK} print 2>/dev/null | grep ${BOOT_DISK} | cut -d: -f6)" = "msdos" ]; then
	echo "MSDOS partition"
	[ "$MMC_RESIZED" == "False" ] && /usr/sbin/parted -s ${BOOT_DISK} resizepart 4 100%
else
	echo "GPT partition"
	check_and_fix_gpt_table
fi

wait_for_dev ${ROOT_DEV} && error_exit "Device ${ROOT_DISK} not exist, restarting"

# Resize rootfs if needed
resize_ext4_fs ${ROOT_DEV}

# Mount root volume
mkdir -p ${ROOT_MNT}
mount -o ${ROOT_MNT_OPT} ${ROOT_DEV} ${ROOT_MNT} || error_exit "cannot mount volume ${ROOT_DEV}"

mount -n -t tmpfs tmpfs $ROOT_MNT/var/volatile
mkdir -p ${ETC_UPPERDIR}
mkdir -p ${ETC_WORKDIR}
mount -t overlay overlay -o ${ETC_MNT_OPT} ${ROOT_MNT}${ETC_MNT} || error_exit "Mounting /etc/ overlay failed"

get_device_by_label "log"
LOG_DEV="${DEVICE_RESULT}"

check_ext4_fs ${LOG_DEV}
mount -o ${LOG_MNT_OPT} ${LOG_DEV} ${ROOT_MNT}${LOG_MNT} || error_exit "cannot mount ${LOG_MNT}"

# Resize data partition
get_device_by_label "data"
DATA_DEV="${DEVICE_RESULT}"
if [ "$MMC_RESIZED" == "False" ]; then
	echo "Resize data partition num: ${DATA_PART_NUM}"
	DATA_PART_NUM=$(get_partition_number_from_device "${DATA_DEV}")
	/usr/sbin/parted -s ${BOOT_DISK} resizepart ${DATA_PART_NUM} 100%
fi

mkdir -p ${ROOT_MNT}${DATA_MNT}
mount -t btrfs -o ${DATA_MNT_OPT} ${DATA_DEV} ${ROOT_MNT}${DATA_MNT} || error_exit "cannot mount ${DATA_MNT}"

# Try to resize data filesystem
/usr/bin/btrfs filesystem resize max ${ROOT_MNT}${DATA_MNT}

mount --move /dev ${ROOT_MNT}/dev
mount --move /sys ${ROOT_MNT}/sys

# Bind /etc/machine-id to data storage
[ -f ${ROOT_MNT}${DATA_MNT}/machine-id ] || touch ${ROOT_MNT}${DATA_MNT}/machine-id

mount -o ${ETC_MACHINE_ID_MNT_OPT} ${ROOT_MNT}${DATA_MNT}/machine-id ${ROOT_MNT}/etc/machine-id || error_exit "cannot bind machine-id"

[ -f ${ROOT_MNT}${DATA_MNT}/hostname ] || cp ${ROOT_MNT}/etc/hostname ${ROOT_MNT}${DATA_MNT}/hostname
mount -o ${HOSTNAME_MNT_OPT} ${ROOT_MNT}${DATA_MNT}/hostname ${ROOT_MNT}/etc/hostname || error_exit "cannot bind hostname"

cleanup

# switch to new rootfs and exec init
exec switch_root ${ROOT_MNT} ${INIT} || error_exit "cannot exec switch_root ${ROOT_MNT} ${INIT}"
