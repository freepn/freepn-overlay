# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="Tooling to ease creating releases"
HOMEPAGE="https://github.com/robotframework/rellu"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/robotframework/rellu.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/robotframework/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/invoke[${PYTHON_USEDEP}]
	dev-python/PyGithub[${PYTHON_USEDEP}]
	test? ( dev-python/twine[${PYTHON_USEDEP}]
		dev-python/wheel[${PYTHON_USEDEP}] )
"

python_test() {
	python_export PYTHON_SITEDIR PYTHON_SCRIPTDIR
	py.test utest/test_version.py
}
