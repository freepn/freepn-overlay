# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python{3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="A small gangla client module written in Python"
HOMEPAGE="https://github.com/sarnold/ganglia_cli"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/ganglia_cli"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	sys-cluster/ganglia"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.3.1[${PYTHON_USEDEP}] )
"

python_test() {
	python_export PYTHON_SITEDIR PYTHON_SCRIPTDIR
	py.test test_"${PN}".py --flake8 "${PN}" -v \
		--cov "${PN}" --cov-report term-missing || die
}
