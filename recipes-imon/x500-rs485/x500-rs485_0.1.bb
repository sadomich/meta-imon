SUMMARY = "RS485 mode enable script and service"
LICENSE = "CLOSED"

SRC_URI = "file://rs485_enable.py \
	file://rs485-mode.service \
	"

inherit systemd

S = "${WORKDIR}"

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 ${WORKDIR}/rs485_enable.py ${D}${bindir}/rs485_enable.py

	install -d ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/rs485-mode.service ${D}${systemd_unitdir}/system/
}

SYSTEMD_SERVICE:${PN} = "rs485-mode.service"

FILES:${PN} += "${bindir}/rs485_enable.py ${systemd_system_unitdir}"
