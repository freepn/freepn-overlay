# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 xdg-utils

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
IUSE=""

# no tests except pylint, so...
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/libdbusmenu-0.6.2[gtk3]
	dev-libs/libappindicator[introspection]
	x11-libs/gtk+:3[introspection]
	x11-libs/libnotify[introspection]
	virtual/notification-daemon
	x11-themes/hicolor-icon-theme
"

DEPEND="${PYTHON_DEPS}
	dev-python/xmltodict[${PYTHON_USEDEP}]
	dev-python/pygobject:3[cairo,${PYTHON_USEDEP}]
	>=dev-python/pycairo-1.20.0[${PYTHON_USEDEP}]
	net-misc/fpnd[polkit,${PYTHON_USEDEP}]
"
# using gnome use flag with this makes repoman choke, but if you actually have
# a gnome desktop you may want to install this:
#   gnome-extra/gnome-shell-extension-appindicator
# but for xfce4 you probably want this:
#   xfce-extra/xfce4-notifyd

DEPEND="${RDEPEND}"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
