# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="https://github.com/andreasvc/pyre2/"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/andreasvc/pyre2.git"
	EGIT_BRANCH="master"
	# for now this is as close as possible to 0.2.23 release
	EGIT_COMMIT="cfc6f2abec098d38e6758347cd1b60bfcdbe72fc"
	inherit git-r3
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
else
	SRC_URI=""
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	dev-libs/re2:=
	>=dev-python/cython-0.20[${PYTHON_USEDEP}]"

DOCS=( AUTHORS README.rst CHANGELIST )

distutils_enable_tests setup.py
