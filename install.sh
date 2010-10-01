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
bindir=$buildroot/$2
rpmmacrosdir=$buildroot/$3

pkgtype=$(bin/distr_vendor -p)
distr=$(bin/distr_vendor -s)
version=$(bin/distr_vendor -v)

echo "Distro: $distr, Version: $version, Pkg: $pkgtype"
mkdir -p $bindir $rpmmacrosdir

DESTFILE=$rpmmacrosdir/macros


if [ $distr = "alt" ] ; then
	DESTFILE=$rpmmacrosdir/intro
	cat macros.base/macros.intro >$DESTFILE
	install -m755 bin/distr_vendor $bindir
else
	cat macros.base/macros.compat macros.base/macros.intro.backport macros.base/macros.intro >$DESTFILE
	install -m755 bin/* $bindir
fi

# Copy .suse.10 or .suse f.i.
for i in $distr.$version $distr ; do
	MI="macros.distro/macros.$i"
	test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI..." ; continue ; }
	cat $MI >>$DESTFILE && break || echo " Failed"
done

# Copy pkgtype related
for i in $pkgtype ; do
	MI="macros.base/macros.$i"
	test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI..." ; continue ; }
	cat $MI >>$DESTFILE && break || echo " Failed"
done

# Add macros copied from ALT's rpm-build-* packages
if [ ! $distr = "alt" ] ; then
	echo >>$DESTFILE
	cat rpm-build/[0-9a-z]* >>$DESTFILE
fi

exit 0
