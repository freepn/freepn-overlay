# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"

inherit distutils eutils

DESCRIPTION="Python crosscompile extensions for distutils"
HOMEPAGE="https://pypi.python.org/pypi/distutilscross"
SRC_URI="https://pypi.python.org/packages/source/d/distutilscross/${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"

IUSE="doc"

DEPEND="dev-python/setuptools"

RDEPEND="${DEPEND}"

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

