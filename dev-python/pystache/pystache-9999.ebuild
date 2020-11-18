# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Python implementation of Mustache"
HOMEPAGE="https://github.com/sarnold/pystache"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/pystache.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/sarnold/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

python_test() {
	distutils_install_for_testing
	pystache-test . ext/spec/specs || die "Test failed with ${EPYTHON}"
}
