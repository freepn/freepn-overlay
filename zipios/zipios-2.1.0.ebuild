# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit cmake-multilib flag-o-matic

DESCRIPTION="Zipios++ is a java.util.zip-like C++ library for reading and writing Zip files."
HOMEPAGE="http://zipios.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~x86"

IUSE="debug doc -test"

## TODO don't forget to package catch...
##   https://github.com/philsquared/Catch
RDEPEND="test? ( app-arch/zip
		app-arch/unzip
		dev-util/catch )
	doc? ( app-doc/doxygen )"

DEPEND="${RDEPEND}
	sys-libs/zlib"

src_prepare() {
	# remove Werror
	sed -i -e 's/-Werror//g' \
		CMakeLists.txt || die

	# correct gentoo doc dir
	sed -i -e "s:share/doc/\${LOWER_TARGET_NAME}:share/doc/${PF}:" \
		doc/CMakeLists.txt || die

	# correct libdir
	sed -i -e "s:N lib:N $(get_libdir):g" \
		src/CMakeLists.txt || die
}

src_configure() {
	strip-unsupported-flags

	local DEBUG_ON=
	use debug && DEBUG_ON="-DCMAKE_BUILD_TYPE=Debug"
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		${DEBUG_ON}
	)
	cmake-multilib_src_configure

	# why oh why does upstream do this?
	for txt_file in $(find ${WORKDIR} -name link.txt) ; do
		sed -i -e "s|rpath|rpath-link|" $txt_file || die "sed failed!"
	done
}
