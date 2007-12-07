# NOTE: do not use clean_spec or rpmcs for this spec

Name: rpm-build-altlinux-compat
Version: 0.95
Release: %{_vendor}1

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
Requires: ed
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
./install.sh %buildroot %_rpmmacrosdir

# Note: rpm does not like doc macros in other sections?
%if %_vendor == "alt"
%files -n rpm-build-compat
%doc AUTHORS TODO NEWS
%_rpmmacrosdir/*
%_bindir/distr_vendor

%else

%files
%defattr(-,root,root)
%doc AUTHORS TODO NEWS ChangeLog
%_rpmmacrosdir/*
%_bindir/*
%endif

%changelog
* Wed Nov 07 2007 Vitaly Lipatov <lav@altlinux.ru> 0.95-alt1
- upgrade dist_vendor script to newest systems
- add check for too old mktemp to add_changelog
- add defaultdocdir definition
- add ChangeLog file
- fix start_service macros
- add initial ArchLinux support
- use lxp suffix for LinuxXP and mdv for Mandriva

* Fri Sep 07 2007 Vitaly Lipatov <lav@altlinux.ru> 0.94-alt1
- update distr_vendor
- add macros start_service for conditional start service during install

* Mon Jul 02 2007 Vitaly Lipatov <lav@altlinux.ru> 0.93-alt1
- upgrade dist_vendor script to newest systems

* Fri Mar 23 2007 Vitaly Lipatov <lav@altlinux.ru> 0.92-alt1
- do not add old ALT distro compatibility macroses for all (fix bug #11183)

* Thu Mar 08 2007 Vitaly Lipatov <lav@altlinux.ru> 0.91-alt1
- rewrite distr_vendor (add detect for all supported system)
- enable make_build to multiprocess build

* Mon Feb 26 2007 Vitaly Lipatov <lav@altlinux.ru> 0.9-alt1
- define post_service macroses separately for rpm and deb

* Thu Feb 22 2007 Vitaly Lipatov <lav@altlinux.ru> 0.8-alt5
- fix distr_vendor script, fixes for dash using
- pack distr_vendor for ALT Linux

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
