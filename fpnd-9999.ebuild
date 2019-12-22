# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6,3_7} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 systemd user

DESCRIPTION="Python package for fpnd node scripts"
HOMEPAGE="https://github.com/sarnold/fpnd"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/fpnd.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="systemd"

RDEPEND="${PYTHON_DEPS}
	net-misc/zerotier"

DEPEND="${PYTHON_DEPS}
	dev-python/daemon[${PYTHON_USEDEP}]
	dev-python/schedule[${PYTHON_USEDEP}]
	dev-python/diskcache[${PYTHON_USEDEP}]
	dev-libs/ztcli-async[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="mirror test"

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
	insinto "${EPREFIX}/etc/${PN}"
	doins "${S}"/etc/"${PN}".ini

	newinitd "${S}"/etc/"${PN}".openrc "${PN}"
	use systemd && systemd_dounit "${S}"/etc/"${PN}".service

	insinto "${EPREFIX}/etc/logrotate.d"
	newins "${S}"/etc/"${PN}".logrotate "${PN}"
}
