# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 udev

MY_PV="${PV/_alpha4/a4}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="Python library to manipulate ESC/POS Printers"
HOMEPAGE="https://github.com/python-escpos/python-escpos"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pyusb-1.0.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-2.0[${PYTHON_USEDEP}]
	>=dev-python/qrcode-4.0[${PYTHON_USEDEP}]
	dev-python/pyserial[${PYTHON_USEDEP}]
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/argcomplete[${PYTHON_USEDEP}]
	dev-python/future[${PYTHON_USEDEP}]
	>=dev-python/viivakoodi-0.8[${PYTHON_USEDEP}]
	virtual/udev
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}"/${P}-allow-arbitrary-usb-arguments.patch )

S="${WORKDIR}/${MY_P}"

# We don't want the extra dependencies:
# jaconv
# tox
# pytest!=3.2.0,!=3.3.0
# pytest-cov
# pytest-mock
# nose
# scripttest
# mock
# hypothesis!=3.56.9
# flake8
RESTRICT="test"

src_install() {
	default
	distutils-r1_python_install

	udev_dorules "${FILESDIR}"/99-escpos.rules

	keepdir /var/spool/lpd
	fowners lp:lp /var/spool/lpd
	fperms g+w /var/spool/lpd
}
