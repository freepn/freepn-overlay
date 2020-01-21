# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="xml"
DISTUTILS_SINGLE_IMPL=1

inherit eutils distutils-r1 prefix

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/ganglia_api"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/freepn/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

DESCRIPTION="API layer that exposes ganglia data in a RESTful JSON manner"
HOMEPAGE="https://github.com/freepn/ganglia_api"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="test"

RDEPEND="${PYTHON_DEPS}
	>=www-servers/tornado-5.1[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? ( dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-flake8[${PYTHON_USEDEP}]
		dev-python/pytest-pep8[${PYTHON_USEDEP}] )"

DOCS=( README.md )

pkg_setup() {
	python-single-r1_pkg_setup
	python_export PYTHON_SITEDIR
}

python_prepare_all()  {
	eprefixify setup.py ganglia/ganglia_api.py
	echo Now setting version... VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version
	VERSION="9999-${EGIT_VERSION}" "${PYTHON}" setup.py set_version || die "setup.py set_version failed"

	# local upstream_url="http://ganglia-api.example.com:8080"
	# local default_url="https://your.monitor.com:PORT"
	# sed -i -e "s|${upstream_url}|${default_url}|" ganglia/settings.py

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install
}

python_install_all() {
	default

	newinitd "${FILESDIR}"/ganglia-api.init ganglia-api
	newconfd "${FILESDIR}"/ganglia-api.conf ganglia-api

	cat >> "${T}"/ganglia-api.env <<- EOF
	CONFIG_PROTECT="${PYTHON_SITEDIR}/ganglia/settings.py"
	EOF
	newenvd "${T}"/ganglia-api.env 20ganglia-api

	# TODO entry_point may not be needed, at least for now.
	# openrc seems okay with this wrapper and cgroups_cleanup
	cat >> "${T}"/ganglia-apid <<- EOF
	#!/bin/sh
	script="${PYTHON_SITEDIR}/ganglia/ganglia_api.py"
	${PYTHON} \$script &
	EOF
	dosbin "${T}"/ganglia-apid

	distutils-r1_python_install_all
}
