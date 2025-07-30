FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://smstools \
	file://nginx \
	"

do_install:append() {
	mkdir -p ${D}${sysconfdir}/logrotate.d

	install -p -m 644 ${WORKDIR}/imon ${D}${sysconfdir}/logrotate.d/
	install -p -m 644 ${WORKDIR}/smstools ${D}${sysconfdir}/logrotate.d/
	install -p -m 644 ${WORKDIR}/nginx ${D}${sysconfdir}/logrotate.d/
}

