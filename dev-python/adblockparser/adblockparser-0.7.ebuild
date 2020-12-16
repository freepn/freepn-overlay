# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )
DISTUTILS_USE_SETUPTOOLS=bdepend
inherit distutils-r1

DESCRIPTION="Python parser for Adblock Plus filters"
HOMEPAGE="https://github.com/scrapinghub/adblockparser"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/scrapinghub/adblockparser.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/scrapinghub/${PN}/archive/${PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-python/py-re2[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

DOCS=( README.rst CHANGES.rst )

distutils_enable_tests pytest

python_test() {
	pytest -vv --doctest-modules --doctest-glob *.rst \
		adblockparser tests || die "Tests fail with ${EPYTHON}"
}
