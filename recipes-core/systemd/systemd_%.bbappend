FILESEXTRAPATHS:prepend := "${THISDIR}/units:${THISDIR}/${PN}:"

SRC_URI += " \
	file://systemd-machine-id.service \
	"

FILES:${PN} += " \
	${systemd_system_unitdir}/systemd-machine-id.service \
	"

do_install:append() {
	install -d ${D}${systemd_system_unitdir}

	# Remove service to committing transient /etc/machine-id
	rm -rf ${D}${systemd_system_unitdir}/systemd-machine-id-commit.service
	rm -rf ${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id-commit.service

	# Custom service to provide a persistant /etc/machine-id on read-write non tmpfs mounting point
	install -d ${D}${systemd_system_unitdir}/systemd/system/sysinit.target.wants
	install -m 0644 ${WORKDIR}/systemd-machine-id.service ${D}${systemd_system_unitdir}/
	ln -sf ../systemd-machine-id.service \
		${D}${systemd_system_unitdir}/sysinit.target.wants/systemd-machine-id.service
}
