# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vitiral/gpio.git"
	EGIT_COMMIT="3bca3c29a29f9494f787b593e7c92c5f7cff1d4f"
	KEYWORDS=""
else
	GIT_COMMIT="3bca3c29a29f9494f787b593e7c92c5f7cff1d4f"
	GIT_BRANCH="master"
	SRC_URI="https://github.com/vitiral/gpio/archive/${GIT_BRANCH}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${GIT_BRANCH}"
fi

DESCRIPTION="Generic python gpio module using the sysfs file access (/sys/class/gpio)."
HOMEPAGE="https://github.com/vitiral/gpio"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
