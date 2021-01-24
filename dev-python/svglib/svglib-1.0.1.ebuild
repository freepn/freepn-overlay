# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="Read SVG files and convert them to other formats"
HOMEPAGE="https://github.com/deeplook/svglib https://pypi.python.org/pypi/svglib/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/deeplook/svglib.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	MY_PV="${PV//_beta/b}"
	SRC_URI="https://github.com/deeplook/${PN}/archive/v${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/reportlab[${PYTHON_USEDEP}]
	dev-python/tinycss2[${PYTHON_USEDEP}]
	dev-python/cssselect2[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest[${PYTHON_USEDEP}] )
"

RESTRICT="!test? ( test )"

python_prepare_all() {
	sed -i '/setup_requires/d' "${S}/setup.py" || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	# deselect downloading test data
	PYTHONPATH="." py.test \
		--deselect tests/test_samples.py::TestWikipediaSymbols \
		--deselect tests/test_samples.py::TestWikipediaFlags \
		--deselect tests/test_samples.py::TestW3CSVG \
		|| die "tests failed"
}
