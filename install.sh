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
archname=$(bin/distr_vendor -a)
# hack for a compatibility
[ "$archname" = "x86" ] && archname="i586"

echo "Distro: $distr, Version: $version, Pkg: $pkgtype"
mkdir -p $bindir $rpmmacrosdir

# See tests/get_macros_distro.sh
# vendor, arch, distro
get_macros_distro()
{
	local REPLBASE=macros.distro/macros
	local PKGVENDOR="$1"
	local ARCH="$2"
	local FINDPKG="$3"

	local ARCHEXT=".$ARCH"
	[ -z "$ARCH" ] && ARCHEXT=


	if [ "$ARCH" = "x86_64" ] ; then
		ls -1 $REPLBASE.$PKGVENDOR*.$ARCH 2>/dev/null | \
			grep -v "$PKGVENDOR\.$ARCH\$"
		echo "$REPLBASE.$FINDPKG.$ARCH"
	else
		ls -1 $REPLBASE.$PKGVENDOR* 2>/dev/null | \
			grep -v "i586" | grep -v "x86_64" | grep -v "$PKGVENDOR\$"
		echo "$REPLBASE.$FINDPKG"
	fi | \
		sort -u | sort -r -n -t . -k 4 | grep "^$REPLBASE.$FINDPKG$ARCHEXT$" -A1000 | sort -r -n -t . -k 4 | head -n2
}

# arch distro version
get_macros_distro_file()
{
	local i
	for i in $(get_macros_distro "$2" "$1" "$2.$3") ; do
		test -r "$i" && echo "$i" && return
	done
	return 1
}


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

# TODO: use fixbashisms project here
fixbashisms()
{
	local DESTFILE="$1"
	# FIXME: we need use bash in rpm for any case?
	# for systems with ash as sh (f.i., Ubuntu)
	bin/subst "s|pushd \(.*\)|cd \1|g" $DESTFILE
	bin/subst "s|popd|cd - >/dev/null|g" $DESTFILE
}

copy_distro_macros()
{
	local mfile
	# Distro/version section. (f.i., .suse.10) or prev. version
	mfile=$(get_macros_distro_file $archname $distr $version)
	if [ -n "$mfile" ] ; then
		copy_macros $mfile
	else
		mfile=$(get_macros_distro_file "" $distr $version)
		copy_macros $mfile
	fi
}

create_distr_vendor_macros()
{
cat <<EOF >macros.distr_vendor

# The distribution info how it was be retrieved via distro_info
%_distro_pkgtype $pkgtype
%_distro_name $(bin/distr_vendor -d)
%_distro_version $version

EOF
}

if [ $distr = "alt" ] ; then
	install -m755 bin/distr_vendor $bindir

	DESTFILE=$rpmmacrosdir/etersoft-intro

	create_distr_vendor_macros
	copy_macros macros.distr_vendor

	# new macros, introduced for ALT and other, but not applied
	copy_macros macros.intro/macros.intro

	# Copy base distro macros (f.i., .alt or alt.x86_64)
	copy_macros macros.distro/macros.$distr macros.distro/macros.$distr.$archname

	DESTFILE=$rpmmacrosdir/etersoft-intro-conflicts
	# conflicts macros introduced for ALT
	# copy base distro macros (f.i., .alt or alt.x86_64)
	copy_macros macros.intro.conflicts/macros.$distr macros.intro.conflicts/macros.$distr.$archname

	if [ "$version" = "Sisyphus" ] ; then
		COMDESTFILE=$rpmmacrosdir/compat
		echo "# This file have to be empty for ALT Linux Sisyphus" >> $COMDESTFILE
		echo "# (see rpm-build-intro and rpm-macros-intro-conflicts packages for real macros)" >> $COMDESTFILE
		echo "# Build at $(date)" >> $COMDESTFILE
	else
		fixbashisms $DESTFILE
		# For ALT will put distro/version section in rpm-build-compat package
		DESTFILE=$rpmmacrosdir/compat

		# TODO: move to separate alt.p6 and so on (what will with non alt? - load it all)
		copy_macros macros.intro/macros.intro.backport

		# alt.p6 and so on
		copy_distro_macros
	fi
else
	DESTFILE=$rpmmacrosdir/$macroname
	# Add macros copied from ALT's rpm-build-* packages
	copy_macros macros.rpm-build/[0-9a-z]*

	# new macros, introduced for ALT and other
	copy_macros macros.intro/macros.intro
	# ALT Linux only macros applied in ALT already (for ALT will add it in distro/version section)
	copy_macros macros.intro/macros.intro.backport

	# Copy pkgtype related ALT compatibility for other platform (f.i., .deb or .deb.x86_64)
	[ "$pkgtype" = "deb" ] || [ "$pkgtype" = "rpm" ] || pkgtype="generic"
	copy_macros macros.base/macros.compat macros.base/macros.$pkgtype macros.base/macros.$pkgtype.$archname


	# Copy base distro macros (f.i., .suse or suse.x86_64)
	copy_macros macros.distro/macros.$distr macros.distro/macros.$distr.$archname

	# suse/11 and so on
	copy_distro_macros

	install -m755 bin/* $bindir

fi


fixbashisms $DESTFILE

ls -l $DESTFILE
