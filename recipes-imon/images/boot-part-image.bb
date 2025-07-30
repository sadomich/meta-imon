DESCRIPTION = "Dummy image to feed Rauc bundle: RAUC_SLOT_boot=boot-part-image"
LICENSE = "MIT"

inherit nopackages deploy

do_fetch[noexec] = "1"
do_patch[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
deltask do_populate_sysroot

do_deploy[depends] += "imon-image:do_image_complete"

python do_deploy() {
    pass
}
addtask deploy after do_install
