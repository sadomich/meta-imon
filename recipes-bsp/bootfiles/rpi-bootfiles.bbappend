
do_deploy:append:raspberrypi3-64() {
	rm -f ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/start4*.elf
	rm -f ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/fixup4*.dat
	rm -f ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/start_x.elf
	rm -f ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/start_db.elf
	rm -f ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/fixup_db.dat
}