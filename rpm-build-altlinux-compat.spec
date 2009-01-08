# NOTE: do not use clean_spec or rpmcs for this spec

Name: rpm-build-altlinux-compat
Version: 1.3
Release: alt1

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
# ALT has it in rpm, but regular rpm requires define it
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

Requires: rpm-build

%description
This package contains ALT Linux compatibility layer
and some extensions for rpm build
on various rpm-based platforms.
Add it to buildrequires when backporting packages.
Command rpmbph from etersoft-build-utils adds it automatically.

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

%prep
%setup -q
find -type d -name CVS | xargs rm -rf

%install
./install.sh %buildroot %_rpmmacrosdir

%if %_vendor == "alt"

%files -n rpm-build-compat
%doc AUTHORS TODO NEWS
%_rpmmacrosdir/compat
%_bindir/distr_vendor

%else

%files
%doc AUTHORS TODO NEWS ChangeLog
%_rpmmacrosdir/macros
%_bindir/add_changelog
%_bindir/stamp_spec
%_bindir/subst
%_bindir/distr_vendor

%endif

%changelog
* Thu Jan 08 2009 Vitaly Lipatov <lav@altlinux.ru> 1.3-alt1
- introduce cmake, fix_permissions, python_check macros

* Wed Dec 10 2008 Yuri Fil <yurifil@altlinux.org> 1.2-alt4
- add compat add_python_req_skip, license macros
- introduce _locksubsysdir macro

* Thu Nov 13 2008 Vitaly Lipatov <lav@altlinux.ru> 1.2-alt3
- fix font path for other system

* Thu Oct 23 2008 Vitaly Lipatov <lav@altlinux.ru> 1.2-alt2
- add modified macroses from rpm-build-fonts for other systems
- bin/distr_vendor: right use status of the last command in functions

* Mon Jun 09 2008 Vitaly Lipatov <lav@altlinux.ru> 1.1-alt2
- fix copy/paste error in add_optflags/remove_optflags

* Sat Jun 07 2008 Vitaly Lipatov <lav@altlinux.ru> 1.1-alt1
- add distro specific macroses support
- set correct fonts path for various distro

* Thu May 08 2008 Vitaly Lipatov <lav@altlinux.ru> 1.00-alt3
- add add_optflags/remove_optflags

* Mon Mar 24 2008 Vitaly Lipatov <lav@altlinux.ru> 1.00-alt2
- disable empty rpmldflags
- ignore return status from groupadd/useradd

* Thu Mar 20 2008 Vitaly Lipatov <lav@altlinux.ru> 1.00-alt1
- fix useradd/groupadd realization again
- update rpm opt* flags

* Sun Mar 02 2008 Vitaly Lipatov <lav@altlinux.ru> 0.99-alt1
- fix useradd/groupadd realization for various distros

* Sun Feb 24 2008 Vitaly Lipatov <lav@altlinux.ru> 0.98-alt1
- add autoreconf macros
- add add_findprov_lib_path skipping
- do not override add_findprov_lib_path and set_verify_elf_method on ArchLinux

* Sat Jan 19 2008 Vitaly Lipatov <lav@altlinux.ru> 0.97-alt1
- do not check tty -s in start_service for other platforms
- check DURING_INSTALL in start_service

* Fri Jan 11 2008 Vitaly Lipatov <lav@altlinux.ru> 0.96-alt1
- add make_install_std, makeinstall_std, omfdir
- cleanup spec according to etersoft-build-utils 1.3.6

* Sat Dec 15 2007 Vitaly Lipatov <lav@altlinux.ru> 0.95-alt2
- add set_verify_elf_method stub for non ALT systems

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
