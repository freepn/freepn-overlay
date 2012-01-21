# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

SUPPORT_PYTHON_ABIS="1"
PYTHON_DEPEND="2:2.5:2.7"

inherit distutils eutils

commit="246b2b7"
MY_PN="astraw-${PN}-${commit}"

DESCRIPTION="Python to Debian source package conversion utility"
HOMEPAGE="http://github.com/astraw/stdeb"
SRC_URI="http://github.com/astraw/${PN}/tarball/release-${PV}/${MY_PN}.tar.gz"
LICENSE="LGPL"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="doc"

DEPEND="dev-python/setuptools
	>=dev-util/debhelper-7"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	cd "${WORKDIR}"
	unpack ${MY_PN}.tar.gz
}

src_install() {
	distutils_src_install

	use doc && dodoc RELEASE_NOTES.txt CHANGELOG.txt
}
