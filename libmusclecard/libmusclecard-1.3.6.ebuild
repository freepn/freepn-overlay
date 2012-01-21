# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ccid/ccid-1.3.11.ebuild,v 1.5 2009/09/27 16:07:40 nixnut Exp $

EAPI="2"

STUPID_NUM="3024"
DESCRIPTION="libmusclecard and bundleTool from PCSC Lite project"
HOMEPAGE="http://pcsclite.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/${STUPID_NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE="debug doc"

RDEPEND=">=sys-apps/pcsc-lite-1.3.3"

DEPEND="${RDEPEND}"

src_configure() {
	local myconf="--enable-muscledropdir=/usr/share/pcsc/services"

	econf ${myconf} \
	    $(use_enable debug)
}

src_install() {
	keepdir /usr/share/pcsc/services

	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc AUTHORS ChangeLog

	# setting doc/datadir in configure doesn't seem to do anything :(
	rm -rf ${D}usr/doc
	if use doc; then
		insinto /usr/share/doc/${P}
		doins doc/muscle-api-1.3.0.pdf
	fi
}
