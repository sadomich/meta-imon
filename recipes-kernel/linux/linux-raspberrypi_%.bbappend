#FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://rauc.cfg \
	file://overlayfs.cfg \
	file://btrfs.cfg \
	file://watchdog.cfg \
	"

SRC_URI:append:rb700-64 = "file://pigeon-led-cm4-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://pigeon-led-usr-cm4-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://pigeon-tpm-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://pigeon-eeprom-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		"

SRC_URI:append:x500-64 = "file://x500-adc-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-hdmi-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-led-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-nxp-uart-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-rtc-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-uart0-rs485-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		file://x500-mcp230xx-overlay.dts;subdir=git/arch/${ARCH}/boot/dts/overlays \
		"

PACKAGE_ARCH = "${MACHINE_ARCH}"
