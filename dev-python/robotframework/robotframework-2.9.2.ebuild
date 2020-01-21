# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1 git-r3

DESCRIPTION="Test automation framework for acceptance testing & test-driven development"
HOMEPAGE="http://robotframework.org/ https://github.com/robotframework/robotframework"

EGIT_REPO_URI="https://github.com/robotframework/robotframework"
EGIT_BRANCH="master"
EGIT_COMMIT="${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+jython"

RDEPEND="jython? ( >=dev-java/jython-2.7.0 )"

PATCHES=( "${FILESDIR}/${P}-fix-task-contexts-and-urllib-imports.patch"
	"${FILESDIR}/${P}-fix-setup_py-syntax.patch"
	"${FILESDIR}/${P}-more-syntax-fixes-for-python3.patch"
	"${FILESDIR}/${P}-remove-broken-tests.patch" )

src_prepare() {
	use jython && eapply "${FILESDIR}/${P}-enable-USE-jython-and-install-jybot.patch"

	eapply_user
	distutils-r1_src_prepare
}

src_test() {
	python_export EPYTHON PYTHON
	${EPYTHON} utest/run.py
	# this one takes a long time and has 14 failures out of 4321 tests
	#${EPYTHON} atest/run.py python --exclude no-ci atest/robot || true
}
