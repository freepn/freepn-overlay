# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="dump binary to hex and restore it back"
HOMEPAGE="https://pypi.python.org/pypi/hexdump"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="public-domain"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

S="${WORKDIR}"
