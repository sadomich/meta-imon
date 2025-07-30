FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://owfs.service \
	file://owfs.conf \
	"

do_install:append() {
	install -d ${D}${sysconfdir}/
	install -d ${D}${systemd_unitdir}/system/

	install -m 0644 ${WORKDIR}/owfs.conf ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/owfs.service ${D}${systemd_unitdir}/system

}
