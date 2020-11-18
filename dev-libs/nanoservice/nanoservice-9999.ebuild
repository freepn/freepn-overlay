# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_5,3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Small Python library for writing lightweight networked services"
HOMEPAGE="https://github.com/walkr/nanoservice"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/nanoservice.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/walkr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-libs/nanomsg-python[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

python_test() {
	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}" pytest -v test2 test \
		|| die "Test failed with ${EPYTHON}"
}
