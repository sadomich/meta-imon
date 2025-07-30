DESCRIPTION = "RAUC bundle generator"

inherit bundle

RAUC_BUNDLE_COMPATIBLE = "iMonOS"
RAUC_BUNDLE_VERSION = "v20200703"
RAUC_BUNDLE_DESCRIPTION = "RAUC iMon Bundle"

BUNDLE_NAME = "${BUNDLE_BASENAME}-${MACHINE}-${DATETIME}-${DISTRO}-${DISTRO_VERSION}"
BUNDLE_LINK_NAME = "${BUNDLE_BASENAME}-${MACHINE}-${DISTRO}"

RAUC_BUNDLE_FORMAT = "verity"

# TODO test smaller block size
BUNDLE_ARGS += '--mksquashfs-args="-comp xz -b 1048576 -Xdict-size 100% -Xbcj x86"'

RAUC_SLOT_boot = "boot-part-image"
RAUC_SLOT_boot[file] = "boot-part.vfat"
RAUC_SLOT_boot[type] = "boot"

RAUC_SLOT_kernel = "imon-kernel-image"
RAUC_SLOT_kernel[type] = "kernel"
RAUC_SLOT_kernel[file] = "kernel.ext4"
RAUC_SLOT_kernel[fstype] = "ext4"
RAUC_SLOT_kernel[adaptive] = "block-hash-index"

RAUC_SLOT_rootfs = "imon-image"
RAUC_SLOT_rootfs[fstype] = "ext4"
RAUC_SLOT_rootfs[adaptive] = "block-hash-index"

RAUC_BUNDLE_SLOTS = "boot kernel rootfs"

RAUC_KEY_FILE = "${THISDIR}/files/imon-dev.key.pem"
RAUC_CERT_FILE = "${THISDIR}/files/imon-dev.cert.pem"
