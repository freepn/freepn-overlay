# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_5,3_6,3_7} )

inherit distutils-r1

DESCRIPTION="Lightweight, pure-Python Text User Interface (TUI) widget toolkit"
HOMEPAGE="https://github.com/pfalcon/picotui"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/pfalcon/picotui"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/pfalcon/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="examples"

RDEPEND="${PYTHON_DEPS}"

DEPEND="${PYTHON_DEPS}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

RESTRICT="test"

PATCHES=( "${FILESDIR}/${P}-add-input-text-validation-to-WLabel-widget.patch" )

src_install() {
	distutils-r1_src_install

	if use examples; then
		docompress -x /usr/share/doc/${PF}/examples
		insinto /usr/share/doc/${PF}
		doins -r examples
		insinto /usr/share/doc/${PF}/examples
		doins example_*.py
	fi
}
