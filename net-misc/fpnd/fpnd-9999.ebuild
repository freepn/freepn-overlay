# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 systemd user

DESCRIPTION="Python package for fpnd node scripts"
HOMEPAGE="https://github.com/freepn/fpnd"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/fpnd.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="systemd test"

RDEPEND="${PYTHON_DEPS}
	net-misc/zerotier"

DEPEND="${PYTHON_DEPS}
	dev-python/daemon[${PYTHON_USEDEP}]
	dev-python/schedule[${PYTHON_USEDEP}]
	dev-python/diskcache[${PYTHON_USEDEP}]
	dev-libs/ztcli-async[${PYTHON_USEDEP}]
	dev-libs/nanoservice[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.5.2[${PYTHON_USEDEP}] )
"

RESTRICT="mirror"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /usr/libexec/${PN} ${PN}
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-make-setup-py-and-ini-conform.patch
	)

	distutils-r1_python_prepare_all
}

python_install() {
	# this is deemed "safe" for a single script
	distutils-r1_python_install --install-scripts="${EPREFIX}/usr/sbin"
}

python_install_all() {
	distutils-r1_python_install_all

	rm "${EPREFIX}//usr/libexec/fpnd/fpnd.ini"
	insinto "/etc/${PN}"
	doins "${S}"/etc/"${PN}".ini

	newinitd "${S}"/etc/"${PN}".openrc "${PN}"
	use systemd && systemd_dounit "${S}"/etc/"${PN}".service

	insinto "/etc/logrotate.d"
	newins "${S}"/etc/"${PN}".logrotate "${PN}"
}

python_test() {
	# Run all but integration tests (requires tox magic)
	#PYTHONPATH="." py.test -v --ignore-glob="tests/integration/*.py"
	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}" py.test test -v \
		|| die "tests failed"
}
