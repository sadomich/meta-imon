FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += "file://boot.cmd.in"

SRC_URI:append:x500-64 = " file://msdos-part.inc"
SRC_URI:append:rb350-64 = " file://msdos-part.inc"
SRC_URI:append:rb700-64 = " file://gpt-part.inc "

do_compile:prepend() {
	if [ "${MACHINE}" = "x500-64" ] || [ "${MACHINE}" = "rb350-64" ]; then
		export KERNEL_PART_A="3"
		export KERNEL_PART_B="5"
		export ROOT_PART_A="6"
		export ROOT_PART_B="7"
	elif [ "${MACHINE}" = "rb700-64" ]; then
		export KERNEL_PART_A="3"
		export KERNEL_PART_B="4"
		export ROOT_PART_A="5"
		export ROOT_PART_B="6"
	fi

	sed -i -e "s#@@KERNEL_PART_A@@#${KERNEL_PART_A}#g" \
		-e "s#@@KERNEL_PART_B@@#${KERNEL_PART_B}#g" \
		-e "s#@@ROOT_PART_A@@#${ROOT_PART_A}#g" \
		-e "s#@@ROOT_PART_B@@#${ROOT_PART_B}#g" \
		${WORKDIR}/boot.cmd.in
}
