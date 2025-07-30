DESCRIPTION = "Create vfat partition with u-boot environmet image file"
LICENSE = "MIT"

inherit nopackages deploy

do_fetch[noexec] = "1"
do_patch[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot

do_deploy[depends] += "\
	dosfstools-native:do_populate_sysroot \
	mtools-native:do_populate_sysroot \
	u-boot:do_deploy \
	"

do_deploy () {
	UBOOTENV_IMG="${WORKDIR}/ubootenv.vfat"
	MKDOSFS_EXTRAOPTS="-S 512"

	rm -f ${UBOOTENV_IMG}

	mkdosfs -n "uboot-env" ${MKDOSFS_EXTRAOPTS} -C ${UBOOTENV_IMG} 8192
	mcopy -i ${UBOOTENV_IMG} -s ${DEPLOY_DIR_IMAGE}/u-boot-initial-env ::/uboot.env
	chmod 644 ${UBOOTENV_IMG}

	mv ${UBOOTENV_IMG} ${DEPLOYDIR}/
}
addtask deploy after do_install



