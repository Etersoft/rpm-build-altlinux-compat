# NOTE: do not use clean_spec or rpmcs for this spec
#TODO: - improve for Mandriva's /etc/rpm/macros.d

Name: rpm-build-altlinux-compat
Version: 0.8
Release: %{_vendor}5

Summary: ALT Linux compatibility and extensions in rpm build

License: GPL
Group: Development/Other
Url: http://wiki.sisyphus.ru/devel/RpmBuildAltlinuxCompat

Packager: Vitaly Lipatov <lav@altlinux.ru>

Source: http://etersoft.ru/download/%name/%name-%version.tar.bz2

BuildArchitectures: noarch

%if %_vendor == "alt" 
%define _rpmmacrosdir %_sysconfdir/rpm/macros.d
%else
%define _rpmmacrosdir /etc/rpm
# ALT has it in RPM
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

%if %_vendor != "suse"
Requires: rpm-build
%endif

# TODO: add version for other distros
# FIXME: do not work :(
#%if_with build_M30
#Requires: rpm-build >= 4.0.4-alt47
#%endif

%description
This package contains ALT Linux compatibility layer
and some extensions for rpm build
on various rpm-based platforms.

%package -n rpm-build-compat
Summary: ALT Linux compatibility and extensions in rpm build
Group: Development/Other
Requires: %_rpmmacrosdir

%description -n rpm-build-compat
This package contains ALT Linux compatibility layer
and some extensions for rpm build
on ALT Linux systems.
It is useful for backporting packages to previous ALT Linux distros.
Add it to buildrequires when backporting packages.
Command rpmbph from etersoft-build-utils adds it automatically.

# This build prepared for ALT backport_distro 

%prep
%setup -q
find -type d -name CVS | xargs rm -rf

%install
#%if %{_vendor} == "RPM"
#rm -rf $RPM_BUILD_ROOT
#%endif

# ALT: /etc/rpm/macros.d
# Scientific: /etc/rpm/macros.name (who else?)
# suse asplinux RPM: macros
DESTFILE=macros
# WARNING: we will override any /etc/rpm/macroses
# I do not know what the platfrom needs it.
#%if %{_vendor} == "redhat"
#DESTFILE=macros.%name
#%endif


%if %_vendor =="alt"
DESTFILE=compat
cat rpm/macros.{altlinux,intro} >rpm/macros.out
%else
cat rpm/macros rpm/macros.intro >rpm/macros.out
mkdir -p %buildroot%_bindir
install -m755 bin/* %buildroot%_bindir
%endif

install -D -m644 rpm/macros.out %buildroot/%_rpmmacrosdir/$DESTFILE

# Note: rpm does not like doc macros in other sections?
%if %_vendor == "alt"
%files -n rpm-build-compat
%doc AUTHORS TODO NEWS
%_rpmmacrosdir/*

%else

%files
%doc AUTHORS TODO NEWS
%_rpmmacrosdir/*
%_bindir/*
%endif

%changelog
* Thu Feb 22 2007 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt5
- fix distro_vendor script, fixes for dash using

* Sun Jan 14 2007 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt4
- remove _libexecdir

* Thu Nov 02 2006 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt3
- fix _libexecdir

* Sat May 13 2006 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt2
- add _docdir
- use nil for correct macro functions
- fix subst script

* Sat Apr 15 2006 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt1
- add dummy macroses for menu/desktopdb update
- add distr_vendor script for distro version detecting
- use : in stub macroses

* Tue Apr 11 2006 Vitaly Lipatov <lav@altlinux.ru> 0.7-alt3
- fix chkconfig params
- change initdir to /etc/init.d (for non ALT)
- rewrite preun/post scripts

* Sun Apr 09 2006 Vitaly Lipatov <lav@altlinux.ru> 0.7-alt2
- revert prev. changes, fix some macroses

* Sun Apr 09 2006 Vitaly Lipatov <lav@altlinux.ru> 0.7-alt1
- define ALT macroses only if not defined yet
- add __niconsdir

* Sat Mar 04 2006 Vitaly Lipatov <lav@altlinux.ru> 0.6-alt1
- fix stupid bug with postun script name
- fix mktemp in old systems

* Sat Feb 18 2006 Vitaly Lipatov <lav@altlinux.ru> 0.5-alt1
- some fixes

* Sun Feb 12 2006 Vitaly Lipatov <lav@altlinux.ru> 0.4-alt1
- merge rpm-build-altlinux-compat and rpm-build-compat projects

* Mon Feb 06 2006 Vitaly Lipatov <lav@altlinux.ru> 0.3-alt1
- fix __autoreconf macro name
- add _aclocaldir macro

* Sun Feb 05 2006 Vitaly Lipatov <lav@altlinux.ru> 0.2-alt1
- add rpmcflags macro

* Sun Jan 29 2006 Vitaly Lipatov <lav@altlinux.ru> 0.1-alt1
- start ALT backports compatibility project

* Fri Dec 30 2005 Vitaly Lipatov <lav@altlinux.ru> 0.3-alt1
- new release, macros updated by Denis Smirnov

* Sat Oct 29 2005 Vitaly Lipatov <lav@altlinux.ru> 0.1-redhat1
- test pre release
