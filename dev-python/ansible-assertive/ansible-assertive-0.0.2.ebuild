# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Make assert more useful for infrastructure testing"
HOMEPAGE="https://github.com/sarnold/ansible-assertive"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/sarnold/ansible-assertive"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/sarnold/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE=""

DEPEND="app-admin/ansible[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

RESTRICT="test"

DOCS=( README.md )

src_compile() {
	:
}

python_install() {
	python_export PYTHON_SITEDIR

	ansible_shared="/usr/share/ansible"
	ansible_plugins="${ansible_shared}/plugins"
	einfo "Using plugin path ${ansible_plugin_path} ..."
	insinto "${ansible_plugins}/callback"
	doins callback_plugins/assertive.py
	insinto "${ansible_plugins}/action"
	doins action_plugins/assert.py
}

pkg_postinst() {
	CFG_FILE="/etc/ansible/ansible.cfg"
	if [[ -e "${CFG_FILE}" ]]; then
		einfo "See the readme on configuring the callback plugin in ${CFG_FILE}:"
	else
		ewarn "You need to create ${CFG_FILE} to configure the callback plugin:"
	fi
	einfo ""
	einfo "callback_whitelist = assertive"
	einfo ""
}
