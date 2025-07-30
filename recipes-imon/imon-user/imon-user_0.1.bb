DESCRIPTION = "Creates imon user with public keys for ssh"
LICENSE = "CLOSED"

inherit useradd

RDEPENDS:${PN} += "bash"

USERADD_PACKAGES = "${PN}"

GROUPADD_PARAM:${PN} = "--gid 2000 --system imon"
USERADD_PARAM:${PN} = "--create-home \
			--system \
			--comment iMon \
			--shell /bin/bash \
			--uid 2000 \
			--gid imon \
			imon"

SRC_URI = "file://authorized_keys"

FILES:${PN} += "/home/imon/.ssh/authorized_keys"

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install () {
	install -d -m 700 ${D}/home/imon/.ssh
	install -m 0600 ${WORKDIR}/authorized_keys ${D}/home/imon/.ssh/authorized_keys
	chown -R imon:imon ${D}/home/imon
}
