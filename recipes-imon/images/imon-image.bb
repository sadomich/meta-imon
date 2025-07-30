DESCRIPTION = "iMon image"
LICENSE = "MIT"

include recipes-core/images/core-image-base.bb

IMAGE_FSTYPES:remove= " ext3 tar.bz2 wic.bz2"
IMAGE_FSTYPES:append = " ext4 wic.xz"

inherit extrausers

do_image[depends] += "imon-kernel-image:do_deploy"

EXTRA_USERS_PARAMS = "usermod -s /bin/bash root; \
			usermod -p '${ROOT_PASSWD}' root; \
			"

EXTRA_USERS_PARAMS += "usermod -p '${IMON_PASSWD}' imon;"

python __anonymous () {
    d.appendVar('ROOTFS_POSTPROCESS_COMMAND', ' remove_boot; ')
}

# Since boot is separate partition remove it from rootfs
remove_boot() {
	rm -rf ${IMAGE_ROOTFS}/boot/*
}

CORE_INSTALL += " openssh \
	openssl \
	openssh-sftp-server \
	bash \
	kernel-modules \
	tzdata \
	watchdog \
	libgpiod \
	libftdi \
	net-config \
	rauc \
	imon-user \
	overlay \
	btrfs-tools \
	imon \
	lsof \
	less \
	grep \
	tcpdump \
	net-config \
	picocom \
	logrotate \
	nftables \
	rsync \
	safe-boot-watchdog \
	"

TOOLS_INSTALL = " strace \
	procps \
	vim \
	can-utils \
	i2c-tools \
	owfs \
	mc \
	sqlite3 \
	"

RPI_INSTALL = " raspi-gpio \
	rpio \
	rpi-gpio \
	pi-blaster \
"

IMAGE_INSTALL += "${CORE_INSTALL}"
IMAGE_INSTALL += "${TOOLS_INSTALL}"
IMAGE_INSTALL += "${RPI_INSTALL}"

IMAGE_INSTALL:append:x500-64 = " i2c-tools x500-rs485"
IMAGE_INSTALL:remove:x500-64 = "owfs"

IMAGE_FEATURE:remove = "splash"

IMAGE_FEATURES += "package-management read-only-rootfs"

OVERLAYFS_ETC_MOUNT_POINT = "/data"

do_image_wic[depends] += "uboot-env-image:do_deploy"

# Rauc optimizations
IMAGE_ROOTFS_ALIGNMENT = "4"
EXTRA_IMAGECMD:ext4 = "-i 4096 -b 4096"

BOOT_PART_IMAGE_BASENAME = "boot-part"
BOOT_PART_IMAGE_EXTENSION = ".vfat"
BOOT_PART_IMAGE_NAME = "${BOOT_PART_IMAGE_BASENAME}-${DATETIME}${BOOT_PART_IMAGE_EXTENSION}"
BOOT_PART_IMAGE_NAME[vardepsexclude] = "DATETIME"
BOOT_PART_IMAGE_LINK_NAME = "${BOOT_PART_IMAGE_BASENAME}${BOOT_PART_IMAGE_EXTENSION}"

create_boot_part_image () {
	build_wic="${WORKDIR}/build-wic"
	install -m 0644 ${WORKDIR}/build-wic/*.p1 ${IMGDEPLOYDIR}/${BOOT_PART_IMAGE_NAME}
	ln -sf ${BOOT_PART_IMAGE_NAME} ${IMGDEPLOYDIR}/${BOOT_PART_IMAGE_LINK_NAME}
}
create_boot_part_image[vardepsexclude] = "DATETIME"

python do_boot_part_image() {
    bb.build.exec_func('create_boot_part_image', d)
}
addtask do_boot_part_image after do_image_wic before do_image_complete
