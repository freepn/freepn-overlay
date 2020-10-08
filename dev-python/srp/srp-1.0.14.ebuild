# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_6,3_7,3_8} )

inherit distutils-r1

MY_PN="py${PN}"

DESCRIPTION="Secure Remote Password protocol in python"
HOMEPAGE="https://github.com/cocagne/pysrp"
SRC_URI="https://github.com/cocagne/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="dev-python/six[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
