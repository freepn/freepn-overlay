# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
WANT_AUTOCONF="2.5"

AUTOTOOLS_AUTORECONF=1

MY_PN="${PN}_${PV}"
MY_BUILD="20170607"

inherit autotools-utils flag-o-matic

DESCRIPTION=""
HOMEPAGE=""
SRC_URI="https://www.phidgets.com/downloads/phidget21/libraries/linux/${PN}/${MY_PN}.${MY_BUILD}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

IUSE="debug doc static-libs zeroconf"

RDEPEND=""

DEPEND="${RDEPEND}
	dev-libs/libusb
	zeroconf? ( net-dns/avahi )"

AUTOTOOLS_IN_SOURCE_BUILD=1

S="${WORKDIR}/${P}.${MY_BUILD}"

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable debug)
		$(use_enable zeroconf)
		--disable-jni
		--disable-labview
	)

	autotools-utils_src_configure
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	find "${D}" -name \*.la -delete || die "failed to remove .la files"
}
