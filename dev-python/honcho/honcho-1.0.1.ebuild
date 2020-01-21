# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python job scheduling for humans"
HOMEPAGE="https://github.com/nickstenning/honcho"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/nickstenning/honcho.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/nickstenning/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.5.2[${PYTHON_USEDEP}] )
"

python_test() {
	# Run all but integration tests (requires tox magic)
	#PYTHONPATH="." py.test -v --ignore-glob="tests/integration/*.py"
	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}" py.test -v \
		|| die "tests failed"
}
