# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_6,3_7,3_8} )

MY_PV="${PV/_p/-}"

inherit distutils-r1

DESCRIPTION="Python job scheduling for humans"
HOMEPAGE="https://github.com/dbader/schedule"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/schedule.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"

BDEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

