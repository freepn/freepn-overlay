# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils autotools

# the date this snapshot update was pulled from upstream git master
MY_PV="git_04132011"
MY_P="${P}-${MY_PV}"

DESCRIPTION="Userspace access to USB devices"
HOMEPAGE="http://libusb.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 -x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="debug doc"

DEPEND="doc? ( app-doc/doxygen )"
RDEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mkdir m4
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable debug debug-log)
}

src_compile() {
	default

	if use doc ; then
		cd doc
		emake docs || die "making docs failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS PORTING README THANKS TODO

	if use doc ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.c

		dohtml doc/html/*
	fi
}
