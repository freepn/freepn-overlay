# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 git-r3

DESCRIPTION="Python binding for Taskwarrior API"
HOMEPAGE="https://github.com/robgolding63/tasklib"

EGIT_REPO_URI="https://github.com/robgolding63/tasklib.git"
if [[ ${PV} = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT=${PV}
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/six[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	dev-python/tzlocal[${PYTHON_USEDEP}]
	"
RDEPEND="${DEPEND} app-misc/task"
