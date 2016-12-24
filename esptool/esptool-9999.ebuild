# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils git-r3

DESCRIPTION="ESP8266 ROM Bootloader utility"
HOMEPAGE="https://github.com/espressif/esptool/"

EGIT_REPO_URI="https://github.com/espressif/esptool.git"
if [[ ${PV} = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT=v${PV}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""

RDEPEND="${DEPEND}
	dev-python/pyserial
	"
