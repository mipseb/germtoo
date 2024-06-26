# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_PN=${PN%-*}
MY_P=${MY_PN}-${PV}
DESCRIPTION="Jolly Good Fork of bsnes"
HOMEPAGE="https://gitlab.com/jgemu/bsnes"
if [[ "${PV}" == *9999 ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.com/jgemu/${MY_PN}.git"
else
	SRC_URI="https://gitlab.com/jgemu/${MY_PN}/-/archive/${PV}/${MY_P}.tar.bz2"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
fi

LICENSE="ISC GPL-3+ LGPL-2.1+ MIT ZLIB"
SLOT="1"

DEPEND="
	media-libs/jg:1=
	media-libs/libsamplerate
"
RDEPEND="
	${DEPEND}
	games-emulation/jgrf
"
BDEPEND="
	virtual/pkgconfig
"

PATCHES=(
	# https://bugs.gentoo.org/891201#c9
	"${FILESDIR}"/${P}-endianness.patch
	# https://bugs.gentoo.org/926077
	"${FILESDIR}"/${P}-strict-aliasing.patch
)

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" PKG_CONFIG="$(tc-getPKG_CONFIG)"
}

src_install() {
	emake install \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}"/usr \
		DOCDIR="${EPREFIX}"/usr/share/doc/${PF} \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}
