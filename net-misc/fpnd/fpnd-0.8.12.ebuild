# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="sqlite"

inherit distutils-r1 linux-info systemd

DESCRIPTION="Python package for fpnd network daemon"
HOMEPAGE="https://github.com/freepn/fpnd"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/fpnd.git"
	EGIT_BRANCH="master"
#	EGIT_COMMIT="89571b4694a19a1180b658ea1684a3bc4f69beab"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="AGPL-3"
SLOT="0"
IUSE="-adhoc polkit systemd sudo test"

RDEPEND="${PYTHON_DEPS}
	sys-apps/iproute2
	net-firewall/iptables
	net-misc/zerotier
	acct-group/fpnd
	acct-user/fpnd
"

DEPEND="${PYTHON_DEPS}
	dev-python/appdirs[${PYTHON_USEDEP}]
	dev-python/daemon[${PYTHON_USEDEP}]
	dev-python/datrie[${PYTHON_USEDEP}]
	dev-python/schedule[${PYTHON_USEDEP}]
	dev-python/diskcache[${PYTHON_USEDEP}]
	dev-libs/ztcli-async[${PYTHON_USEDEP}]
	dev-libs/nanoservice[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( >=dev-python/mock-2.0.0[${PYTHON_USEDEP}]
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
		>=dev-python/coverage-4.5.2[${PYTHON_USEDEP}] )
"
# additional test dependcies not required for USE=test
#	dev-python/pytest-cov
#	dev-python/pytest-pep8
#	dev-python/pytest-flake8
#	dev-python/tox

DOCS=( README.rst README_adhoc-mode.rst )

pkg_setup() {
	linux-info_pkg_setup

	CONFIG_CHECK_MODULES="TUN IP_NF_NAT NET_SCHED BPFILTER IFB \
	NET_SCH_INGRESS IP_MULTIPLE_TABLES NETFILTER_XT_TARGET_MARK \
	IP_ADVANCED_ROUTER NF_CT_NETLINK NETFILTER_NETLINK_QUEUE NF_NAT \
	NETFILTER_NETLINK_LOG NETFILTER_XT_NAT IP_NF_MANGLE NF_DEFRAG_IPV4 \
	IP_NF_TARGET_MASQUERADE IP_NF_FILTER IP_NF_IPTABLES NF_CONNTRACK \
	NETFILTER_XT_MARK NETFILTER_XTABLES NET_SCH_CODEL NET_SCH_FQ_CODEL"

	if linux_config_exists; then
		for module in ${CONFIG_CHECK_MODULES}; do
			linux_chkconfig_present ${module} || ewarn "${module} needs to be enabled in kernel"
		done
	else
		ewarn "No kernel config found; you will need to ensure your running"
		ewarn "kernel has tun, nat/netfilter modules, and xt_mark enabled!"
	fi
}

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/${PN}-make-setup-py-and-ini-conform.patch
	)
	if use systemd; then
		sed -i -e "s|usr/lib|usr/libexec|" "${S}"/etc/"${PN}".ini
	else
		PATCHES+=( "${FILESDIR}"/${PN}-set-openrc-paths.patch )
	fi

	distutils-r1_python_prepare_all
}

python_install() {
	# this is deemed "safe" for a single script
	distutils-r1_python_install --install-scripts="${EPREFIX}/usr/bin"

	python_fix_shebang "${ED}"/usr/libexec/fpnd
}

python_install_all() {
	distutils-r1_python_install_all

	rm "${ED}/usr/libexec/fpnd/fpnd.ini"
	use adhoc || sed -i -e "s|adhoc|peer|" "${S}"/etc/"${PN}".ini

	insinto "/etc/${PN}"
	doins "${S}"/etc/"${PN}".ini

	newinitd "${S}"/etc/"${PN}".openrc "${PN}"
	use systemd && systemd_dounit "${S}"/etc/"${PN}".service

	newconfd "${FILESDIR}"/"${PN}".conf "${PN}"
	insinto "/etc/logrotate.d"
	newins "${S}"/etc/"${PN}".logrotate "${PN}"

	if use sudo; then
		insinto /etc/sudoers.d/
		insopts -m 0440 -o root -g root
		newins "${S}/cfg/fpnd.sudoers" fpnd
	elif use polkit; then
		insinto /etc/polkit-1/rules.d/
		doins "${S}"/cfg/55-fpnd-systemd.rules
		doins "${S}"/cfg/55-fpnd-openrc.rules
	fi
}

python_test() {
	distutils_install_for_testing
	PYTHONPATH="${TEST_DIR}/lib:${PYTHONPATH}" py.test test -v \
		|| die "tests failed"
}
