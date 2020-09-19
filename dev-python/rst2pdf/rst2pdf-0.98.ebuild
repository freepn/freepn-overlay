# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="Tool for transforming reStructuredText to PDF using ReportLab"
HOMEPAGE="https://rst2pdf.org/ https://pypi.org/project/rst2pdf/"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="svg"

BDEPEND="${PYTHON_DEPS}
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pdfrw[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/smartypants[${PYTHON_USEDEP}]
	>=dev-python/reportlab-2.6[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/docutils[${PYTHON_USEDEP}]
	svg? ( media-gfx/svg2rlg[${PYTHON_USEDEP}] )
	test? ( >=dev-python/pytest-3.0.3[${PYTHON_USEDEP}] )
"

# >=reportlab-2.6: https://code.google.com/p/rst2pdf/issues/detail?id=474

distutils_enable_tests pytest

src_install() {
	distutils-r1_src_install
	pushd "${S}/doc" > /dev/null
		rst2man.py rst2pdf.rst output/rst2pdf.1
	popd > /dev/null
	doman doc/output/rst2pdf.1
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "rst2pdf can work with the following packages for additional functionality:"
		elog "   dev-python/sphinx       - versatile documentation creation"
		elog "   dev-python/pythonmagick - image processing with ImageMagick"
		elog "   dev-python/matplotlib   - mathematical formulae"
		elog "It can also use wordaxe for hyphenation, but this package is not"
		elog "available in the portage tree yet. Please refer to the manual"
		elog "installed in /usr/share/doc/${PF}/ for more information."
	fi
}
