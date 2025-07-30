SUMMARY = "Library for the M-Bus (Meter-Bus) protocol"
HOMEPAGE = "https://github.com/rscada/libmbus"
LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1465a6da368848cdb2501d332f0e2f29"

#DEPENDS += "libtool-native"

SRC_URI = "git://github.com/rscada/libmbus.git;protocol=https;branch=master \
    file://CMakeLists.txt \
    file://config.h \
    "

SRCREV = "7d4e89f6eeaf2000157b952e000f297c052ce18f"

S = "${WORKDIR}/git"

#inherit autotools

EXTRA_OECONF = ""

#do_configure[depends] += "libtool-native:do_populate_sysroot"

inherit pkgconfig cmake

#inherit autotools pkgconfig

DEPENDS += "autoconf-native automake-native libtool-native"

do_configure:prepend() {
    install ${WORKDIR}/CMakeLists.txt ${S}
    install ${WORKDIR}/config.h ${S}
}

#do_configure:prepend() {
#    # Clean old Makefile if present to force autotools regen
#    [ -f ${S}/Makefile ] && rm -f ${S}/Makefile
#    cd ${S}
#    ./build.sh
#}