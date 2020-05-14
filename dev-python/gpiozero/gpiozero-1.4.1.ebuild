# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} )

inherit distutils-r1

MY_PN="python-${PN}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A simple interface to GPIO devices with Raspberry Pi"
HOMEPAGE="https://github.com/RPi-Distro/python-gpiozero"
SRC_URI="https://github.com/RPi-Distro/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"
