# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="${PN/_/-}"
MY_P="${MY_PN}-${PV}"

DISTUTILS_SINGLE_IMPL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Nagios plugin command for checking all ganglia metrics"
HOMEPAGE="https://github.com/freepn/check_ganglia"

SRC_URI="https://github.com/freepn/check_ganglia/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="net-analyzer/nagios-core
	sys-cluster/ganglia"

S="${WORKDIR}/${PN/-/_}-${PV}"
