# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-fs/btrfs-progs/btrfs-progs-0.19-r3.ebuild,v 1.1 2011/06/05 16:34:06 lavajoe Exp $

inherit eutils

DESCRIPTION="Btrfs filesystem utilities"
HOMEPAGE="http://btrfs.wiki.kernel.org/"
SRC_URI="http://www.kernel.org/pub/linux/kernel/people/mason/btrfs/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm ppc64 x86"
IUSE="debug-utils"

DEPEND="debug-utils? ( dev-python/matplotlib )
        sys-apps/acl
        sys-fs/e2fsprogs"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Apply changes from btrfs-progs-0.19-23.el6.src.rpm (Oracle Linux)
	epatch "${FILESDIR}/${PN}-0.19-23.ol6.patch"

	# Fix hardcoded "gcc" and "make"
	sed -i -e 's:gcc $(CFLAGS):$(CC) $(CFLAGS):' Makefile
	sed -i -e 's:make:$(MAKE):' Makefile
}

src_compile() {
	emake CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" all || die
}

src_install() {
	into /
	dosbin btrfs
	dosbin btrfs-show
	dosbin btrfs-vol
	dosbin btrfsctl
	dosbin btrfsck
	dosbin btrfstune
	dosbin btrfs-image
	dosbin btrfs-convert
	dosbin btrfs-map-logical
	dosbin btrfs-zero-log

	dosym btrfsck /sbin/fsck.btrfs
	newsbin mkfs.btrfs mkbtrfs
	dosym mkbtrfs /sbin/mkfs.btrfs
	dosbin btrfs-convert

	if use debug-utils; then
		dobin btrfs-debug-tree
	else
		ewarn "Note: btrfs-debug-tree not installed (requires debug-utils USE flag)"
	fi

	into /usr
	newbin bcp btrfs-bcp

	if use debug-utils; then
		newbin show-blocks btrfs-show-blocks
	else
		ewarn "Note: btrfs-show-blocks not installed (requires debug-utils USE flag)"
	fi

	dodoc INSTALL

	emake prefix="${D}/usr/share" install-man
}
