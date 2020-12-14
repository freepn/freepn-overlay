# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/andreasvc/pyre2/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/py-re2.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV="${PV/_p/-}"
	SRC_URI="https://github.com/freepn/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/re2:=
	!dev-python/pyre2
	$(python_gen_cond_dep '>=dev-python/cython-0.20[${PYTHON_USEDEP}]' 'python*')
"

DOCS=( AUTHORS README.rst CHANGELOG.rst )

distutils_enable_tests setup.py

python_prepare_all() {
	sed -i -e "s|'lib'|'$(get_libdir)'|g" setup.py

	distutils-r1_python_prepare_all
}
