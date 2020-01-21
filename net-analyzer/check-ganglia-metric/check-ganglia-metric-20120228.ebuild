# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="check_ganglia_metric"
MY_PV="2012.02.28"
MY_P="${MY_PN}-${MY_PV}"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Nagios plugin command for checking ganglia metrics"
HOMEPAGE="https://pypi.org/project/check_ganglia_metric/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="net-analyzer/nagaconda
	net-analyzer/nagios-core
	sys-cluster/ganglia"

S="${WORKDIR}/${MY_P}"
