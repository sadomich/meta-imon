SUMMARY = "Initramfs image init scripts"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/COPYING.MIT;md5=3da9cfbcb788c80a0384361b4de20420"

SRC_URI = "file://initramfs-init.sh"

RDEPENDS:${PN} = "busybox \
	gptfdisk \
	parted \
	grep \
	btrfs-tools \
	e2fsprogs-resize2fs \
	e2fsprogs \
	watchdog \
	"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${base_sbindir}
	install -m 0755 ${WORKDIR}/initramfs-init.sh ${D}${base_sbindir}/init

	install -d ${D}/dev
	mknod -m 622 ${D}/dev/console c 5 1
}

inherit allarch

FILES:${PN}  += "/sbin/init /dev/console"