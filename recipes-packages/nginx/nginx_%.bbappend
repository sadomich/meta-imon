FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
	file://default_server.site \
	file://fastcgi-php.conf \
	"

do_install:append() {
#	install -Dm 0644 ${WORKDIR}/default_server.site ${D}${sysconfdir}/nginx/sites-available/default_server

	install -d ${D}${sysconfdir}/nginx/snippets
	install -Dm 0644 ${WORKDIR}/fastcgi-php.conf ${D}${sysconfdir}/nginx/snippets
}
