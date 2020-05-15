# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="ganglia-modules"
MY_P="${MY_PN}-${PV}"

inherit eutils

DESCRIPTION="Ganglia Python modules for thermal sensors"
HOMEPAGE="https://github.com/freepn/ganglia-modules"

if [[ ${PV} = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/freepn/ganglia-modules"
	EGIT_BRANCH="master"
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/freepn/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_P}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="sys-cluster/ganglia[python]
	sys-apps/lm-sensors
	app-admin/hddtemp"

DEPEND="dev-vcs/git
	${RDEPEND}"

src_install() {
	confdir="/etc/ganglia/conf.d"
	moduledir="/usr/$(get_libdir)/ganglia/python_modules"

	insinto "${confdir}"
	doins conf.d/hddtemp.pyconf conf.d/lm_sens.pyconf

	insinto "${moduledir}"
	doins pymodules/hddtemp.py pymodules/lm_sens.py
}
