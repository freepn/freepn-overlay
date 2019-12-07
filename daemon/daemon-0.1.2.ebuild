# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_5,3_6,3_7} )

inherit distutils-r1 git-r3

DESCRIPTION="Python daemonizer for Unix, Linux and OS X"
HOMEPAGE="https://github.com/serverdensity/python-daemon"

# this is a one-off because upstream has no github release (only pypi)
# and we need the packaging fixes
EGIT_REPO_URI="https://github.com/sarnold/python-daemon.git"
EGIT_BRANCH="install-fixes"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )
"

python_test() {
	nosetests -v . || die "Testing failed with ${EPYTHON}"
}
