# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy pypy3 )
DISTUTILS_OPTIONAL="y"

inherit autotools distutils-r1 toolchain-funcs

DESCRIPTION="Extra tools for Python Documentation Utilities for slides, ODT, etc"
HOMEPAGE="https://github.com/VCTLabs/docutils-extras"
if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/VCTLabs/docutils-extras.git"
	EGIT_BRANCH="master"
	inherit git-r3
else
	SRC_URI="https://github.com/VCTLabs/${PN}/archive/RELEASE_${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="MIT "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="dev-python/docutils[${PYTHON_USEDEP}]
	dev-python/rst2pdf"
RDEPEND="${DEPEND}"

src_prepare() {
	local version="${PV}"
	sed "s/@VERSION@/${version}/g" configure.ac.in > configure.ac

	eautoreconf -vfi
}
