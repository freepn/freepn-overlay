# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python{3_5,3_6,3_7} )

EGIT_REPO_URI="https://github.com/pytries/datrie.git"
EGIT_SUBMODULES=(
	libdatrie
)

inherit distutils-r1 git-r3

if [[ ${PV} = 9999* ]]; then
	EGIT_BRANCH="master"
	SRC_URI=""
	KEYWORDS=""
else
	EGIT_COMMIT="3881491cfe69c6b70c9371d36b0be614c493652a"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="Fast, efficiently stored Trie for Python. Uses libdatrie."
HOMEPAGE="https://github.com/pytries/datrie"

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-libs/libdatrie
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		<=dev-python/hypothesis-4.57.1[${PYTHON_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-use-system-libdatrie.patch"
)

python_test() {
	py.test -v || die "Testing failed with ${EPYTHON}"
}
