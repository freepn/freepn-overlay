# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python3_4 )

inherit distutils-r1

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/xhtml2pdf/xhtml2pdf.git"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="PDF generator using HTML and CSS"
HOMEPAGE="http://www.xhtml2pdf.com/ https://pypi.python.org/pypi/xhtml2pdf/"

IUSE="test"
LICENSE="Apache-2.0"
SLOT="0"

DEPEND="dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/PyPDF2[${PYTHON_USEDEP}]
	dev-python/httplib2[${PYTHON_USEDEP}]
	>=dev-python/reportlab-3[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}] )"

RDEPEND="${DEPEND}"
