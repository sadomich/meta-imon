SUMMARY = "Mount overlayfs RW on read-only rootfs"
DESCRIPTION = "Make /var/lib and /root writeable"

LICENSE = "MIT"
LIC_FILES_CHKSUM="file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

PV = "1.0"

SRC_URI = " \
	file://mount-overlay.sh \
	file://overlay-var-lib-dir.service \
	file://overlay-root-dir.service \
"

inherit systemd

SYSTEMD_AUTO_ENABLE = "enable"
SYSTEMD_SERVICE:${PN} = "overlay-var-lib-dir.service overlay-root-dir.service"

do_install () {
	install -d ${D}${systemd_system_unitdir}
	install -d ${D}${base_sbindir}

	install -m 0755 ${WORKDIR}/mount-overlay.sh ${D}${base_sbindir}/

	install -m 0644 ${WORKDIR}/overlay-var-lib-dir.service ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/overlay-root-dir.service ${D}${systemd_system_unitdir}
}
