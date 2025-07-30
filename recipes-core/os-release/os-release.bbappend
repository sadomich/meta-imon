# Configure BUILD_ID

inherit imon-distro-version

IMON_MACHINE_ID = "${MACHINE}"
BUILD_ID = "${DATETIME}"
BUILD_ID[vardepsexclude] = "DATETIME"

OS_RELEASE_FIELDS:remove = "VERSION_ID"
OS_RELEASE_FIELDS:append = " BUILD_ID"
OS_RELEASE_FIELDS:append = " IMON_MACHINE_ID"

BB_DONT_CACHE = "1"
