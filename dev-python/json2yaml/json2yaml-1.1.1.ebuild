# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Converts JSON to YAML or vice versa, preserving the order of associative arrays."
HOMEPAGE="http://pypi.python.org/pypi/json2yaml"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~arm ~arm64 ~x86"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}
	dev-python/pretty-yaml[${PYTHON_USEDEP}]
	dev-python/docopt[${PYTHON_USEDEP}]"
