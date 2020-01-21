# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_5,3_6,3_7} )

# note the p1 is to denote the big patch on top of upstream 1.0 release
MY_PV="${PV/_p1/}"

inherit distutils-r1

DESCRIPTION="nanomsg wrapper for python with multiple backends (CPython and ctypes)"
HOMEPAGE="https://github.com/tonysimpson/nanomsg-python"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/nanomsg-python.git"
	EGIT_BRANCH="python-tests"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/tonysimpson/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-libs/nanomsg:=
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

PATCHES=( "${FILESDIR}/updates-from-master-plus-intpacker-fix.patch" )

S="${WORKDIR}/${PN}-${MY_PV}"

python_test() {
	"${EPYTHON}" -m nose -sv . || die "Testing failed with ${EPYTHON}"
}
