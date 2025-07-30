FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://fw_env.config \
	file://0001-Adapt-to-Rauc-A-B-partition-layout.patch \
	file://imon.cfg \
"

do_install:append () {
	install -d ${D}${sysconfdir}
	install -m 0644 ${WORKDIR}/fw_env.config ${D}${sysconfdir}/fw_env.config
}
