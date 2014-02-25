# vendor, arch
get_macros_distro()
{
	local REPLBASE=macros.distro/macros
	local PKGVENDOR="$1"
	local ARCH="$2"
	local FINDPKG="$3"

	local ARCHEXT=".$ARCH"
	[ -z "$ARCH" ] && ARCHEXT=


	if [ -n "$ARCH" ] ; then
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
}



echo "--- empty "
get_macros_distro debian "" debian.7.0
echo "---"
get_macros_distro debian "" debian.7
echo "---"
get_macros_distro ubuntu "" ubuntu.13.10

echo
echo "--- i586"
get_macros_distro debian "i586" debian.7.0
echo "---"
get_macros_distro debian "i586" debian.7
echo "---"
get_macros_distro ubuntu "i586" ubuntu.13.10

echo
echo "--- x86_64"
get_macros_distro debian "x86_64" debian.7.0
echo "---"
get_macros_distro debian "x86_64" debian.7
echo "---"
get_macros_distro ubuntu "x86_64" ubuntu.13.10
echo "---"

get_macros_distro ubuntu "x86_64" ubuntu.10.04


echo
echo "###"
get_macros_distro_file x86_64 ubuntu 13.04
get_macros_distro_file i586 ubuntu 13.04
get_macros_distro_file "" ubuntu 13.04
get_macros_distro_file i586 ubuntu 13.04
