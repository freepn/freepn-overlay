# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

PYTHON_COMPAT=( python2_7 )
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="*-jython"

inherit eutils python-r1 toolchain-funcs

DESCRIPTION="Object-oriented python bindings for subversion"
HOMEPAGE="http://pysvn.tigris.org/"
SRC_URI="http://pysvn.barrys-emacs.org/source_kits/${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~x86-freebsd ~x86-linux ~ppc-macos ~x86-solaris"
IUSE="doc examples"

RDEPEND=">=dev-python/pycxx-6.2.0
	<dev-vcs/subversion-1.7.0"
DEPEND="${RDEPEND}
	dev-python/setuptools"

src_prepare() {
	# Don't use internal copy of dev-python/pycxx.
	rm -fr Import

	# Fix harmless SyntaxErrors with Python 3.
	sed -e "/^DISTDIR=/d" -i Source/pysvn_common.mak

	# fix test bug on python3
	epatch "${FILESDIR}"/${P}-tests-with-webdav.patch

	python_copy_sources

	preparation() {
		cd Source
		if has "${PYTHON_ABI}" 2.4 2.5; then
			"$(PYTHON)" setup.py backport || die "Backport failed"
		fi
	}
	python_execute_function -s preparation
}

src_configure() {
	configuration() {
		cd Source
		"$(PYTHON)" setup.py configure \
			--pycxx-src-dir="${EPREFIX}/usr/share/python$(python_get_version)/CXX" \
			--apr-inc-dir="${EPREFIX}/usr/include/apr-1" \
			--svn-root-dir="${EPREFIX}/usr" || return 1

		sed \
			-e 's:^\(CCFLAGS=\)\(.*\):\1$(CFLAGS) \2:g' \
			-e 's:^\(CCCFLAGS=\)\(.*\):\1$(CXXFLAGS) \2:g' \
			-e "/^CCC=/s:g++:$(tc-getCXX):" \
			-e "/^CC=/s:gcc:$(tc-getCC):" \
			-e "/^LDSHARED=/s:g++:$(tc-getCXX) ${LDFLAGS}:" \
			-i Makefile || die "sed failed"
	}
	python_execute_function -s configuration
}

src_compile() {
	building() {
		cd Source
		emake
	}
	python_execute_function -s building
}

src_test() {
	testing() {
		cd Source
		emake test || return 1
		emake -C ../Tests || return 1
	}
	python_execute_function -s testing
}

src_install() {
	installation() {
		cd Source/pysvn
		exeinto "$(python_get_sitedir)/pysvn"
		doexe _pysvn*$(get_modname) || die "doexe failed"
		insinto "$(python_get_sitedir)/pysvn"
		doins __init__.py || die "doins failed"
	}
	python_execute_function -s installation

	if use doc; then
		dohtml -r Docs/ || die "dohtml failed"
	fi

	if use examples; then
		docinto examples
		dodoc Examples/Client/* || die "dodoc examples failed"
	fi
}

pkg_postinst() {
	python_mod_optimize pysvn
}

pkg_postrm() {
	python_mod_cleanup pysvn
}
