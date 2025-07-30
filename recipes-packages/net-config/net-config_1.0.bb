SUMMARY = "Network Configuration"
SECTION = "Diagnostic"

LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

inherit systemd

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = "file://copy-net-config.service "

SRC_URI:append:x500-64 = "file://80-eth0.network"
SRC_URI:append:rb350-64 = "file://80-eth0.network"
SRC_URI:append:rb700-64 = "file://80-eth0.network file://80-eth1.network"

SYSTEMD_SERVICE:${PN} = "copy-net-config.service"

do_install() {
	install -d ${D}/${systemd_unitdir}/network
	install -m 644 ${WORKDIR}/80-eth0.network ${D}${systemd_unitdir}/network

	if [ -f "${WORKDIR}/80-eth1.network" ]; then
		install -m 644 ${WORKDIR}/80-eth1.network ${D}${systemd_unitdir}/network
	fi

	install -d ${D}${systemd_unitdir}/system/
	install -m 0644 ${WORKDIR}/copy-net-config.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += "${systemd_unitdir}/network ${systemd_unitdir}/system/"

