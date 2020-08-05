# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="tcp_only_forwarder"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python3_{6,7,8} )
inherit python-single-r1

DESCRIPTION="Lightweight TCP-only DNS forwarder with DoT support"
HOMEPAGE="https://github.com/m3047/tcp_only_forwarder"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/m3047/tcp_only_forwarder.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
	# S="${WORKDIR}/${MY_P}"
else
	SRC_URI="https://github.com/sarnold/mini-dot/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="systemd"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}"

RESTRICT="test"

src_install() {
	python_doscript forwarder.py

	newinitd "${FILESDIR}"/"${PN}".openrc "${PN}"
	newconfd "${FILESDIR}"/"${PN}".confd "${PN}"

	use systemd && systemd_dounit "${FILESDIR}"/"${PN}".service

}
