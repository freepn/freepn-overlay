# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Python package for fpnd node scripts"
HOMEPAGE="https://github.com/sarnold/fpnd"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/fpnd.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE=""

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/daemon[${PYTHON_USEDEP}]
	dev-python/diskcache[${PYTHON_USEDEP}]
	dev-libs/ztcli-async[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
"
