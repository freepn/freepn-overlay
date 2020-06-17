# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

LLVM_MAX_SLOT=10

inherit flag-o-matic llvm systemd toolchain-funcs user

HOMEPAGE="https://www.zerotier.com/"
DESCRIPTION="A software-based managed Ethernet switch for planet Earth"

if [[ ${PV} = 9999* ]]; then
	EGIT_REPO_URI="https://github.com/freepn/ZeroTierOne.git"
	EGIT_BRANCH="master"
	inherit git-r3
	KEYWORDS=""
else
	SRC_URI="https://github.com/zerotier/ZeroTierOne/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="BSL-1.1"
SLOT="0"
IUSE="clang neon"

S="${WORKDIR}/ZeroTierOne-${PV}"

RDEPEND="
	>=dev-libs/json-glib-0.14
	>=net-libs/libnatpmp-20130911
	net-libs/miniupnpc:=
	clang? ( >=sys-devel/clang-6:= )"

DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-respect-ldflags.patch"
	"${FILESDIR}/${P}-add-armv7a-support.patch"
	"${FILESDIR}/${P}-fixup-neon-support.patch" )

DOCS=( README.md AUTHORS.md )

llvm_check_deps() {
	if use clang ; then
		if ! has_version --host-root "sys-devel/clang:${LLVM_SLOT}" ; then
			ewarn "sys-devel/clang:${LLVM_SLOT} is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		if ! has_version --host-root "=sys-devel/lld-${LLVM_SLOT}*" ; then
			ewarn "=sys-devel/lld-${LLVM_SLOT}* is missing! Cannot use LLVM slot ${LLVM_SLOT} ..."
			return 1
		fi

		einfo "Will use LLVM slot ${LLVM_SLOT}!"
	fi
}

pkg_pretend() {
	( [[ ${MERGE_TYPE} != "binary" ]] && ! test-flag-CXX -std=c++11 ) && \
		die "Your compiler doesn't support C++11. Use GCC 4.8, Clang 3.3 or newer."
}

pkg_setup() {
	enewgroup zerotier-one
	enewuser zerotier-one -1 -1 /var/lib/zerotier-one zerotier-one

	llvm_pkg_setup
}

src_compile() {
	if use clang && ! tc-is-clang ; then
		einfo "Enforcing the use of clang due to USE=clang ..."
		export CC=${CHOST}-clang
		export CXX=${CHOST}-clang++
		strip-unsupported-flags
		replace-flags -ftree-vectorize -fvectorize
		replace-flags -flto* -flto=thin
		# append-ldflags -fuse-ld=lld
	elif ! use clang && ! tc-is-gcc ; then
		einfo "Enforcing the use of gcc due to USE=-clang ..."
		export CC=${CHOST}-gcc
		export CXX=${CHOST}-g++
		append-flags -fPIC
	fi

	tc-export CC CXX

	use neon || export ZT_DISABLE_NEON=1

	append-ldflags -Wl,-z,noexecstack
	emake CXX="${CXX}" STRIP=: one
}

src_test() {
	emake selftest
	./zerotier-selftest || die
}

src_install() {
	default
	# remove pre-zipped man pages
	rm "${ED}"/usr/share/man/{man1,man8}/*

	newinitd "${FILESDIR}/${PN}".init "${PN}"
	systemd_dounit "${FILESDIR}/${PN}".service

	doman doc/zerotier-{cli.1,idtool.1,one.8}
}
