# NOTE: do not use clean_spec or rpmcs for this spec

Name: rpm-build-altlinux-compat
Version: 0.4
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
%define _rpmmacrosdir /etc/rpm
# ALT has it in RPM
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

%if %_vendor != "suse"
Requires: rpm-build
%endif

# TODO: add version for other distros
# FIXME: do not work :(
%if_with build_M30
Requires: rpm-build >= 4.0.4-alt47
%endif

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

%prep
%setup -q
find -type d -name CVS | xargs rm -rf

%install
#%if %{_vendor} == "RPM"
#rm -rf $RPM_BUILD_ROOT
#%endif

# ALT: /etc/rpm/macros.d
# RHEL: /etc/rpm/macros.name
DESTFILE=macros
%if %{_vendor} == "redhat"
DESTFILE=macros.%name
%endif

# suse asplinux RPM: macros

%if %_vendor =="alt"
DESTFILE=compat
install -D -m644 rpm/macros.altlinux %buildroot/%_rpmmacrosdir/$DESTFILE
%else
install -D -m644 rpm/macros %buildroot/%_rpmmacrosdir/$DESTFILE
mkdir -p %buildroot%_bindir
install -m755 bin/* %buildroot%_bindir
%endif

%if %_vendor =="alt"
%files -n rpm-build-compat
%doc AUTHORS TODO NEWS
%_rpmmacrosdir/*
%else
%files
%doc AUTHORS TODO NEWS
%_bindir/*
%_rpmmacrosdir/*
%endif

%changelog
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
