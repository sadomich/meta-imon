SUMMARY = "Watchdog kicker during early boot until systemd is ready"
DESCRIPTION = "Periodically kicks /dev/watchdog during system boot to prevent unwanted reset until systemd is running or timeout is reached."

LICENSE = "CLOSED"

SRC_URI = "file://safe-boot-watchdog.sh \
	file://safe-boot-watchdog.service \
	"

S = "${WORKDIR}"

inherit systemd

SYSTEMD_SERVICE:${PN} = "safe-boot-watchdog.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    # Skrypt do /usr/sbin
    install -d ${D}${sbindir}
    install -m 0755 ${WORKDIR}/safe-boot-watchdog.sh ${D}${sbindir}/

    # Jednostka systemd
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/safe-boot-watchdog.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir} ${sbindir}/safe-boot-watchdog.sh"
