# Configure BUILD_ID

inherit imon-distro-version

python() {
    git_desc = run_git(d, 'git describe HEAD --tags --long')
    if git_desc:
        d.setVar('GIT_DESC', git_desc)
    else:
        bb.fatal('Unable to get git tag info')
}

IMON_MACHINE_ID = "${MACHINE}"
BUILD_ID = "${GIT_DESC}-${DATETIME}"
BUILD_ID[vardepsexclude] = "DATETIME"

OS_RELEASE_FIELDS:remove = "VERSION_ID"
OS_RELEASE_FIELDS:append = " BUILD_ID"
OS_RELEASE_FIELDS:append = " IMON_MACHINE_ID"

BB_DONT_CACHE = "1"
