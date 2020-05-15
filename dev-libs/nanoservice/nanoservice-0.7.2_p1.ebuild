# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )

MY_PV="${PV//_}"

inherit distutils-r1

DESCRIPTION="Small Python library for writing lightweight networked services"
HOMEPAGE="https://github.com/walkr/nanoservice"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/nanoservice.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-libs/nanomsg-python[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		!dev-python/pytest-cases
	)
"

PATCHES=( "${FILESDIR}/${PN}-remove-deps-fromsetup-py.patch" )

python_test() {
	has userpriv $FEATURES && eerror "Multiproc tests may fail with FEATURES=userpriv"

	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}" pytest -v test2/ test/ \
		|| die "Test failed with ${EPYTHON}"
}
