# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 python3_{5,6} )

inherit distutils-r1 eutils

MY_PV="release-${PV}"

DESCRIPTION="Python to Debian source package conversion utility"
HOMEPAGE="https://github.com/astraw/stdeb"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/astraw/stdeb.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/astraw/stdeb/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="doc"

DEPEND="app-arch/dpkg
	>=dev-util/debhelper-7"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

src_install() {
	distutils-r1_src_install

	use doc && dodoc RELEASE_NOTES.txt CHANGELOG.txt
}
