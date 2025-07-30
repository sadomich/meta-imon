DESCRIPTION = "Create vfat partition with u-boot environmet image file"
LICENSE = "MIT"

inherit nopackages deploy

do_fetch[noexec] = "1"
do_patch[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot

DEPENDS = "virtual/kernel ${INITRAMFS_IMAGE}"

do_deploy[depends] += "\
	mtools-native:do_populate_sysroot \
	e2fsprogs-native:do_populate_sysroot \
	virtual/kernel:do_deploy \
	${INITRAMFS_IMAGE}:do_image_complete \
	virtual/kernel:do_bundle_initramfs \
	"

do_deploy () {
	KERNELSOURCEDIR="${WORKDIR}/kernel/"
	KERNELIMG="${WORKDIR}/kernel.ext4"

	mkdir -p ${KERNELSOURCEDIR}
	cp ${DEPLOY_DIR_IMAGE}/${KERNEL_IMAGETYPE}-initramfs-${MACHINE}.bin ${KERNELSOURCEDIR}/Image

	dd if=/dev/zero of=${KERNELIMG} bs=1M count=128
	mkfs.ext4 -F -i 4096 -b 4096 ${KERNELIMG} -d ${KERNELSOURCEDIR}

	mv ${KERNELIMG} ${DEPLOYDIR}/
	rm -rf ${KERNELSOURCEDIR}
	rm -f ${KERNELIMG}
}
addtask deploy after do_install


