# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Refactoring tool for migrating from unittest to pytest."
HOMEPAGE="https://github.com/pytest-dev/unittest2pytest"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/pytest-dev/unittest2pytest.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	# SRC_URI="https://github.com/pytest-dev/${PN}/releases/download/v${PV}/${P}.tar.gz"
	SRC_URI="https://github.com/pytest-dev/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-3.3.0[${PYTHON_USEDEP}] )
"
