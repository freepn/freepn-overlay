# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

DESCRIPTION="Changelog generator based on github milestones or tags"
HOMEPAGE="https://github.com/spyder-ide/loghub"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/spyder-ide/loghub.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/spyder-ide/loghub/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/jinja[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
	)
"

DOCS=( CHANGELOG.md README.md RELEASE.md )

S="${WORKDIR}/loghub-${PV}"

PATCHES=( "${FILESDIR}/${P}-fix-unmarked-github-test.patch" )

distutils_enable_tests pytest

python_test() {
	NOT_ON_CI=true py.test -x -vv loghub \
		|| die "Tests failed with ${EPYTHON}"
}
