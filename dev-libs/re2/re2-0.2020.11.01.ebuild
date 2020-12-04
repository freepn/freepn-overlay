# Copyright 2012-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake multilib-minimal

# Different date format used upstream.
RE2_VER=${PV#0.}
RE2_VER=${RE2_VER//./-}

DESCRIPTION="An efficient, principled regular expression library"
HOMEPAGE="https://github.com/google/re2"
SRC_URI="https://github.com/google/re2/archive/${RE2_VER}.tar.gz -> re2-${RE2_VER}.tar.gz"

LICENSE="BSD"
# NOTE: Always run libre2 through abi-compliance-checker!
# https://abi-laboratory.pro/tracker/timeline/re2/
SONAME="9"
SLOT="0/${SONAME}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="icu test"

BDEPEND="icu? ( virtual/pkgconfig )"
DEPEND="icu? ( dev-libs/icu:0=[${MULTILIB_USEDEP}] )
	!icu? ( app-i18n/unicode-data )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/re2-${RE2_VER}"

DOCS=( AUTHORS CONTRIBUTORS README doc/syntax.txt )
HTML_DOCS=( doc/syntax.html )

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${P}-cmake-findICU-test.patch"
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DHAVE_ICU=$(usex icu)
		-DRE2_BUILD_TESTING=$(usex test)
	)

	cmake_src_configure
}

multilib_src_compile() {
	cmake_src_compile
}

multilib_src_test() {
	local myctestargs=(
		-E 'dfa|exhaustive|random'
	)

	cmake_src_test
}

multilib_src_install() {
	cmake_src_install
}
