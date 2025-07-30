SUMMARY = "M-Bus Python Library"
DESCRIPTION = "A Python library for reading M-Bus (Meter-Bus) devices"
HOMEPAGE = "https://github.com/ganehag/pyMeterBus"

LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=74cb7060ce959ee98b188a44a1146d7d"

SRC_URI = "git://github.com/ganehag/pyMeterBus.git;branch=master;protocol=https"
SRCREV = "f0d6ae22f3943a2f7e1e7cc58bb9a615dbc98ffc"

RDEPENDS:${PN} += "python3-pycryptodome"

S = "${WORKDIR}/git"

inherit setuptools3

RDEPENDS:${PN} += "python3-pyserial"
