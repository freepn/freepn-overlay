# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1 cmake

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/andreasvc/pyre2/"

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/py-re2.git"
	EGIT_BRANCH="skbuild"
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

RDEPEND="dev-libs/re2:="
DEPEND="${RDEPEND}"
BDEPEND="dev-python/cython[${PYTHON_USEDEP}]
	dev-python/scikit-build[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}] )
"

DOCS=( AUTHORS README.rst CHANGELOG.rst )

RESTRICT="!test? ( test )"

python_prepare_all() {
	if [[ ${PV} != *9999* ]]; then
		sed -i -e "s|'lib'|'$(get_libdir)'|g" setup.py
	fi

	distutils-r1_python_prepare_all
}

src_configure() {
	python_setup
	PYTHON_LIB_PATH="$(python_get_sitedir)"
	local mycmakeargs=(
		-DCMAKE_MODULE_PATH="${PYTHON_LIB_PATH}/skbuild/resources/cmake;${S}/CMake"
	)

	cmake_src_configure
	distutils-r1_src_configure
}

python_test() {
	# Run doc tests first, needs extension
	PYTHONPATH="${BUILD_DIR}/src" nosetests -sx tests/re2_test.py || die "doc tests failed"
	PYTHONPATH="${BUILD_DIR}/src" nosetests -sx tests/test_re.py || die "tests failed"
}

src_test() {
	python_test
}
