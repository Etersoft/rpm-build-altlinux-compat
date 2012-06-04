#!/bin/sh -x

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
archname=$(uname -m)

echo "Distro: $distr, Version: $version, Pkg: $pkgtype"
mkdir -p $bindir $rpmmacrosdir

DESTFILE=$rpmmacrosdir/$macroname

# Add files from param to DESTFILE
copy_macros()
{
	local MI
	for MI in $@ ; do
		test -r "$MI" && echo "Applied $MI..." || { echo "Skipping $MI (missed)..." ; continue ; }
		echo >>$DESTFILE
		echo "# Included from file $MI" >>$DESTFILE
		cat $MI >>$DESTFILE
	done
}

if [ $distr = "alt" ] ; then
	DESTFILE=$rpmmacrosdir/etersoft-intro
	echo -n >$DESTFILE
	# new macros, introduced for ALT and other, but not applied
	copy_macros macros.intro/macros.intro
	install -m755 bin/distr_vendor $bindir
else
	echo -n >$DESTFILE
	# new macros, introduced for ALT and other
	copy_macros macros.intro/macros.intro
	# ALT Linux only macros applied in ALT already (for ALT will add it in distro/version section)
	copy_macros macros.intro/macros.intro.backport

	# Copy pkgtype related ALT compatibility for other platform (f.i., .deb or .deb.x86_64)
	[ "$pkgtype" = "deb" ] || [ "$pkgtype" = "rpm" ] || pkgtype="generic"
	copy_macros macros.base/macros.compat macros.base/macros.$pkgtype macros.base/macros.$pkgtype.$archname

	install -m755 bin/* $bindir
fi

# Copy base distro macros (f.i., .suse or suse.x86_64)
copy_macros macros.distro/macros.$distr macros.distro/macros.$distr.$archname

if [ $distr = "alt" ] ; then
	# For ALT will put distro/version section in rpm-build-compat package
	DESTFILE=$rpmmacrosdir/compat
	echo -n >$DESTFILE
	if [ "$version" = "Sisyphus" ] ; then
		echo "# This file have to be empty after build in ALT Linux Sisyphus (check rpm-build-intro package)" >> $DESTFILE
		echo "# Build at $(date)" >> $DESTFILE
	else
		copy_macros macros.intro/macros.intro
		# TODO: move to separate alt.p6 and so on (what will with non alt? - load it all)
		copy_macros macros.intro/macros.intro.backport
		# ALT Linux only macros applied in ALT already (for ALT will add it in distro/version section)
		copy_macros macros.distro/macros.$distr
	fi
else
	# Add macros copied from ALT's rpm-build-* packages
	copy_macros macros.rpm-build/[0-9a-z]*
fi

# Distro/version section. (f.i., .suse.10)
if [ -r macros.distro/macros.$distr.$version.$archname ] ; then
	copy_macros macros.distro/macros.$distr.$version.$archname
else
	copy_macros macros.distro/macros.$distr.$version
fi

# FIXME: we need use bash in rpm for any case?
# for systems with ash as sh (f.i., Ubuntu)
bin/subst "s|pushd \(.*\)|cd \1|g" $DESTFILE
bin/subst "s|popd|cd - >/dev/null|g" $DESTFILE
ls -l $DESTFILE

exit 0
