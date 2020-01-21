# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="Ganglia linux modules"
HOMEPAGE="https://github.com/ganglia/ganglia-modules-linux"
SRC_URI="https://github.com/ganglia/${PN}/archive/${PV}.tar.gz -> ${PN}-${PV}.tar.gz"
#S="${WORKDIR}/${PN}-${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="sys-cluster/ganglia"
DEPEND="sys-devel/autoconf
	sys-devel/automake
	sys-devel/libtool
	virtual/pkgconfig
	${RDEPEND}"

# bug 123456
AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	mkdir m4
	eapply_user
	eautoreconf
}

src_configure() {
	my_hz=$(awk '{print$22/'$(tail -n 1 /proc/uptime|cut -d. -f1)"}" /proc/self/stat | cut -d. -f1)
	append-libs -ltirpc
	append-cppflags -DHZ=${my_hz} -I/usr/include/tirpc

	APR_FLAGS=$(apr-1-config --cflags --includes)
	append-cflags ${APR_FLAGS}
	econf --docdir="\$(datarootdir)/doc/${PF}/html" \
		--enable-shared \
		--disable-static \
		--prefix="${EROOT}/usr"
}

src_install() {
	default

	# remove conflicting module already provided in ganglia package
	rm -f "${ED}"/usr/lib/ganglia/modmulticpu.*
}
