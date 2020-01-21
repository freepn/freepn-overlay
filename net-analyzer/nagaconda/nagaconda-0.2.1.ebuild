# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MY_PN="NagAconda"
MY_P="${MY_PN}-${PV}"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bonesmoses/NagAconda"
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${MY_P}"
	PATCHES=( "${FILESDIR}/${P}-fix-NoneType-error.patch" )
fi

DESCRIPTION="A loose framework to produce Nagios plugins"
HOMEPAGE="https://github.com/bonesmoses/NagAconda"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="net-analyzer/nagios-core
	sys-cluster/ganglia"
