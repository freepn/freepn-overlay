# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1 xdg

DESCRIPTION="Graphical user interface for fpnd control and status"
HOMEPAGE="https://github.com/freepn/freepn-gtk3-tray"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/freepn-gtk3-tray.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="gnome"

# no tests, so...
RESTRICT="test"

COMMON_DEPEND="${PYTHON_DEPS}
	dev-libs/libappindicator[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
"
RDEPEND="${COMMON_DEPEND}
"
DEPEND="${PYTHON_DEPS}
	gnome? ( gnome-extra/gnome-shell-extension-appindicator )
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	net-misc/fpnd[${PYTHON_USEDEP}]
"
