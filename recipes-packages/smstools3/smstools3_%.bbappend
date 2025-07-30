FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://0001-Setup-modem-tty-before-start.patch \
	file://smsd.conf \
	file://smssend \
	file://smstools.service \
	"

RDEPENDS:${PN} = "gawk bash"

inherit systemd

do_install:append () {
	install -d ${D}${sysconfdir}
	install -m 644 ${WORKDIR}/smsd.conf ${D}${sysconfdir}/smsd.conf

	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/smssend ${D}${bindir}
	install -m 755 ${S}/scripts/sms3 ${D}${bindir}

	install -d ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/smstools.service ${D}${systemd_system_unitdir}/smstools.service
}

SYSTEMD_SERVICE:${PN} = "smstools.service"

FILES:${PN}:append = "${bindir}"