
# Disable visual mode on mouse select by default
do_install:append() {
	echo "set mouse-=a" >> ${D}/${datadir}/${BPN}/${VIMDIR}/defaults.vim
	echo "set nobackup" >> ${D}/${datadir}/${BPN}/${VIMDIR}/defaults.vim
	echo "set noundofile" >> ${D}/${datadir}/${BPN}/${VIMDIR}/defaults.vim
}
