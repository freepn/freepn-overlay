# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="A ReSTFUL frontend to Ganglia exposing metrics via HTTP"
HOMEPAGE="https://github.com/dcarrollno/Ganglia-Modules/wiki/GangliaRest-API:-Part-I"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE="mvebu64 redis"

RDEPEND="
	>=sys-cluster/ganglia-3.7.1[${PYTHON_USEDEP}]
	redis? ( dev-db/redis
		 dev-libs/hiredis
		 dev-python/redis-py )
"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/packaging[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/webpy[${PYTHON_USEDEP}]
"

PATCHES=( "${FILESDIR}/${PN}-fix-setup.patch" )

DOCS=( README.txt )

src_prepare() {
	use mvebu64 && sed -i -e "s|eth0|lan1|" "${S}"/gangliarest/gangliaRest.py

	default

	mkdir -p "${S}"/bin
	cat >> "${S}"/bin/GangliaRest <<- EOF
	#!/usr/bin/env bash
	python -m gangliarest.gangliaRest "\$@"
	EOF
}

python_install() {
	distutils-r1_python_install

	sed -e "s:python:${EPYTHON}:" bin/GangliaRest > "${T}"/GangliaRest || die
	python_doexe "${T}"/GangliaRest
}

python_install_all() {
	default
	insinto /etc/
	doins "${S}"/etc/GangliaRest.cfg
	newinitd "${FILESDIR}"/gangliarest.init gangliarest
	distutils-r1_python_install_all
}
