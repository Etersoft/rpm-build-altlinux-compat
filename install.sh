#!/bin/sh

# ALT: /etc/rpm/macros.d
# Scientific: /etc/rpm/macros.name (who else?)
# suse asplinux RPM: macros
# DESTFILE=macros
# WARNING: we will override any /etc/rpm/macroses
# I do not know what the platfrom needs it.
#%if %{_vendor} == "redhat"
#DESTFILE=macros.%name
#%endif

buildroot=$1
rpmmacrosdir=$2
bindir=$buildroot/usr/bin

pkgtype=$(bin/distr_vendor -p)
distr=$(bin/distr_vendor)
echo "Distro: $distr, Pkg: $pkgtype"
mkdir -p $bindir $buildroot/$rpmmacrosdir

DESTFILE=$buildroot/$rpmmacrosdir/macros

if [ $distr = "alt" ] ; then
	DESTFILE=$buildroot/$rpmmacrosdir/compat
	cat rpm/macros.altlinux rpm/macros.intro >$DESTFILE
	install -m755 bin/distr_vendor $bindir
else
	cat rpm/macros rpm/macros.altlinux rpm/macros.intro >$DESTFILE
	install -m755 bin/* $bindir
	[ ! $pkgtype = "deb" ] && pkgtype="rpm"
	cat rpm/macros.$pkgtype >>$DESTFILE
fi

exit 0
