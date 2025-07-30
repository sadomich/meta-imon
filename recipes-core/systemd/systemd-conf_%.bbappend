FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += " \
	file://journald.conf \
	file://override.conf \
	file://system-watchdog.conf \
	"

do_install:append() {
	install -d ${D}${systemd_system_unitdir}/systemd-journal-flush.service.d
	install -m 0644 ${WORKDIR}/override.conf ${D}${systemd_system_unitdir}/systemd-journal-flush.service.d

	install -D -m0644 ${WORKDIR}/system-watchdog.conf ${D}${systemd_unitdir}/system.conf.d/01-${PN}-watchdog.conf
}

FILES:${PN} += "\
	${systemd_system_unitdir}/systemd-journal-flush.service.d/ \
"
