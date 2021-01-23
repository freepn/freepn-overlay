# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A personal adblocking and filtering privacy proxy"
HOMEPAGE="https://github.com/freepn/freepn-proxy"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/freepn-proxy.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="test"

RDEPEND="
	net-misc/wget
	dev-libs/nss
	dev-python/lxml[${PYTHON_USEDEP}]
	>=net-proxy/mitmproxy-5.3.0[${PYTHON_USEDEP}]
	dev-python/importlib_resources[${PYTHON_USEDEP}]
	>=dev-python/appdirs-1.4.4[${PYTHON_USEDEP}]
	dev-python/munch[${PYTHON_USEDEP}]
	dev-python/adblockparser[${PYTHON_USEDEP}]
	>=dev-python/beautifulsoup-4.4.1[${PYTHON_USEDEP}]
	>=dev-python/psutil-5.7.0[${PYTHON_USEDEP}]
	>=dev-python/py-re2-0.3.2[${PYTHON_USEDEP}]
"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="!test? ( test )"

python_prepare_all() {
	sed -i -e "s|==|>=|g" setup.cfg || die
	distutils-r1_python_prepare_all
}

python_test() {
	distutils_install_for_testing
	freepn-proxy --test || die "Selftest failed with ${EPYTHON}"
	${EPYTHON} ${S}/freepn/adblock/test/adblock_test.py
}
