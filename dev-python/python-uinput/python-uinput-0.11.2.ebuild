# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=(python{3_6,3_7,3_8})

inherit distutils-r1

DESCRIPTION="Pythonic API to the Linux uinput kernel module"
HOMEPAGE="http://tjjr.fi/sw/python-uinput/"

if [[ ${PV} = 9999 ]]; then
	EGIT_REPO_URI="https://github.com/tuomasjjrasanen/python-uinput"
	EGIT_BRANCH="master"
	KEYWORDS=""
	inherit git-r3
else
	SRC_URI="https://github.com/tuomasjjrasanen/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="virtual/udev"
RDEPEND="${DEPEND}"

DOCS="AUTHORS NEWS.rst README.rst"

python_prepare_all() {
	rm libsuinput/src/libudev.h || die
	distutils-r1_python_prepare_all
}
