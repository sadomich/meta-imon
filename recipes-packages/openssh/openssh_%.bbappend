FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FILES:${PN} += "${sysconfdir}/ssh/sshd_config"

SRC_URI += " \
	file://sshdgenkeys.service \
	"

do_install:append () {
	install -m 0644 ${WORKDIR}/sshd_config ${D}${sysconfdir}/ssh/

	# Create config files for read-only rootfs
	install -d ${D}${sysconfdir}/ssh
	install -m 644 ${D}${sysconfdir}/ssh/sshd_config ${D}${sysconfdir}/ssh/sshd_config_readonly
	sed -i '/HostKey/d' ${D}${sysconfdir}/ssh/sshd_config_readonly
	echo "HostKey /data/ssh/ssh_host_rsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
	echo "HostKey /data/ssh/ssh_host_ecdsa_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
	echo "HostKey /data/ssh/ssh_host_ed25519_key" >> ${D}${sysconfdir}/ssh/sshd_config_readonly
}
