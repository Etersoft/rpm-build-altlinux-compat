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
	DESTFILE=$rpmmacrosdir/etersoft-intro
	# new macros, introduced for ALT and other, but not applied
	cat macros.intro/macros.intro >$DESTFILE
	install -m755 bin/distr_vendor $bindir
else
	# new macros, introduced for ALT and other
	cat macros.intro/macros.intro >$DESTFILE
	# ALT Linux only macros applied in ALT already (for ALT will add it in distro/version section)
	cat macros.intro/macros.intro.backport >>$DESTFILE

	# Copy pkgtype related ALT compatibility for other platform
	for i in compat $pkgtype ; do
		MI="macros.base/macros.$i"
		test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI..." ; continue ; }
		echo >>$DESTFILE
		cat $MI >>$DESTFILE && break || echo " Failed"
	done

	install -m755 bin/* $bindir
fi

if [ $distr = "alt" ] ; then
	# For ALT will put distro/version section in rpm-build-compat package
	DESTFILE=$rpmmacrosdir/compat
else
	# Add macros copied from ALT's rpm-build-* packages
	echo >>$DESTFILE
	cat macros.rpm-build/[0-9a-z]* >>$DESTFILE
fi

# Distro/version section. Copy .suse.10 or .suse f.i.
for i in $distr.$version $distr ; do
	MI="macros.distro/macros.$i"
	test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI..." ; continue ; }
	cat $MI >>$DESTFILE && break || echo " Failed"
done

exit 0
