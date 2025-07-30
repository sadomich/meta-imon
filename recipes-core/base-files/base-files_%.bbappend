
RDEPENDS:${PN} += "coreutils"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

BB_DONT_CACHE = "1"

SRC_URI += "file://issue.template "

dirs755 += "/data"
dirs755 += "/uboot_env"
dirs755 += "/mnt/1wire"

do_install:append() {
	install -d ${D}${ROOT_HOME}

	install -m 0755 ${WORKDIR}/share/dot.bashrc ${D}${ROOT_HOME}/.bashrc
	install -m 0755 ${WORKDIR}/share/dot.profile ${D}${ROOT_HOME}/.profile
}

do_install_imon_issue() {
	sed -e 's,__DISTRO_VERSION__,${DISTRO_VERSION},g' ${WORKDIR}/issue.template > ${D}${sysconfdir}/issue
}
BASEFILESISSUEINSTALL = "do_install_imon_issue"
do_install_imon_issue[vardeps] += "DISTRO_VERSION"
