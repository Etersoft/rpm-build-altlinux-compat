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
macroname=$4

pkgtype=$(bin/distr_vendor -p)
distr=$(bin/distr_vendor -s)
version=$(bin/distr_vendor -v)

echo "Distro: $distr, Version: $version, Pkg: $pkgtype"
mkdir -p $bindir $rpmmacrosdir

DESTFILE=$rpmmacrosdir/$macroname

# Add files from param to DESTFILE
copy_macros()
{
	for MI in $@ ; do
		test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI..." ; continue ; }
		echo >>$DESTFILE
		echo "# Included from file $MI" >>$DESTFILE
		cat $MI >>$DESTFILE
	done
}

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
	[ "$pkgtype" = "deb" ] || [ "$pkgtype" = "rpm" ] || pkgtype="generic"
	copy_macros macros.base/macros.compat macros.base/macros.$pkgtype

	install -m755 bin/* $bindir
fi

# Copy base distro macros (f.i., .suse)
copy_macros macros.distro/macros.$distr

if [ $distr = "alt" ] ; then
	# For ALT will put distro/version section in rpm-build-compat package
	DESTFILE=$rpmmacrosdir/compat
	echo -n >$DESTFILE
	if [ "$version" = "Sisyphus" ] ; then
		echo "# This file have to be empty after build in ALT Linux Sisyphus (check backported package)" >> $DESTFILE
		echo "# Build at $(date)" >> $DESTFILE
	fi
else
	# Add macros copied from ALT's rpm-build-* packages
	copy_macros macros.rpm-build/[0-9a-z]*
fi

# Distro/version section. (f.i., .suse.10)
copy_macros $distr.$version

# for systems with ash as sh (f.i., Ubuntu)
subst "s|pushd \(.*\)|cd \1|g" $DESTFILE
subst "s|popd|cd - >/dev/null|g" $DESTFILE

exit 0
