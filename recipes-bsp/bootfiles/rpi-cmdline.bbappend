
#CMDLINE_SERIAL = ""
#CMDLINE_SERIAL = "console=tty1 console=serial0,115200"
CMDLINE_SERIAL = "console=tty1"

CMDLINE_ROOTFS = "rootfstype=ext4 rootwait"

CMDLINE_DEBUG = "loglevel=4 audit=0"

CMDLINE += " SYSTEMD_UNIT_PATH=/data/systemd/system/:"
