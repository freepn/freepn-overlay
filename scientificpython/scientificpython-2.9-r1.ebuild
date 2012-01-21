# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/scientificpython/scientificpython-2.9-r1.ebuild,v 1.1 2010/02/17 21:43:59 jlec Exp $

EAPI="3"
SUPPORT_PYTHON_ABIS="1"

inherit distutils eutils

MY_PN="ScientificPython"
DV="2372" # hardcoded download version

DESCRIPTION="Scientific Module for Python"
SRC_URI="http://sourcesup.cru.fr/frs/download.php/${DV}/${MY_PN}-${PV}.tar.gz"
HOMEPAGE="http://sourcesup.cru.fr/projects/scientific-py/"

LICENSE="CeCILL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc mpi test"

RDEPEND="dev-python/numpy
	>=sci-libs/netcdf-4
	mpi? ( virtual/mpi )"

DEPEND="${RDEPEND}
	test? ( dev-python/nose )"

#	|| ( =sci-libs/netcdf-3.6* >=sci-libs/netcdf-4 )
RESTRICT_PYTHON_ABIS="3.*"

S="${WORKDIR}/${MY_PN}-${PV}.0"

PYTHON_MODNAME="Scientific"

src_prepare() {
	distutils_src_prepare
	epatch "${FILESDIR}/${P}-mpi.patch"
#	use mpi && epatch "${FILESDIR}/${P}-mpi-netcdf.patch"
}

src_compile() {
	distutils_src_compile
	if use mpi; then
		cd Src/MPI
		building_of_mpipython() {
			PYTHONPATH="$(ls -d ../../build-${PYTHON_ABI}/lib*)" "$(PYTHON)" compile.py
			mv -f mpipython mpipython-${PYTHON_ABI}
		}
		python_execute_function --action-message 'Building of mpipython with Python ${PYTHON_ABI}...' --failure-message 'Building of mpipython failed with Python ${PYTHON_ABI}' building_of_mpipython
	fi
}

src_test() {
	cd Tests
	testing() {
		PYTHONPATH="$(ls -d ../build-${PYTHON_ABI}/lib.*)" nosetests-${PYTHON_ABI}
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	# do not install bsp related stuff, since we don't compile the interface
	dodoc README README.MPI Doc/CHANGELOG || die "dodoc failed"
	insinto /usr/share/doc/${PF}
	doins Examples/{demomodule.c,netcdf_demo.py} || die "doins examples failed"

	if use mpi; then
		installation_of_mpipython() {
			dobin Src/MPI/mpipython-${PYTHON_ABI}
		}
		python_execute_function -q installation_of_mpipython
		python_generate_wrapper_scripts "${ED}usr/bin/mpipython"
		doins Examples/mpi.py || die "doins mpi example failed failed"
	fi

	if use doc; then
		dohtml Doc/Reference/* || die "dohtml failed"
	fi
}
