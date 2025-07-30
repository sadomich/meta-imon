
SUMMARY = "A tool which makes AT communication easier."
HOMEPAGE = "https://github.com/sixfab/atcom"
AUTHOR = "Bugra Isguzar <bugra@sixfab.com>"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://setup.py;md5=6a55dab08573e10e74f10c5c5ccb4e08"

SRC_URI = "https://files.pythonhosted.org/packages/73/86/18beae538d190150b3ddbeb2a53e97282c2ff2d09fa814171a4e1a63a518/atcom-0.4.3.tar.gz"
SRC_URI[md5sum] = "1e466f2b4a33099438b897695b906c76"
SRC_URI[sha256sum] = "fa32ecefed5f0f757d7899ab04be4ccce418998b6f4ce16380563adaa3b5d5e2"

S = "${WORKDIR}/atcom-0.4.3"

RDEPENDS:${PN} = "python3-click python3-pyyaml python3-pyserial python3-difflib"

inherit setuptools3
