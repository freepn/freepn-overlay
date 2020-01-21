# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="ESP8266 ROM Bootloader utility"
HOMEPAGE="http://pypi.python.org/pypi/esptool"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/pyserial
	"
