# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

DESCRIPTION="Python daemonizer for Unix, Linux and OS X"
HOMEPAGE="https://github.com/freepn/python-daemon"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/python-daemon.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/freepn/python-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/python-${P}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	"${EPYTHON}" -m pytest -v test_daemon.py \
		|| die "Testing failed with ${EPYTHON}"
}
