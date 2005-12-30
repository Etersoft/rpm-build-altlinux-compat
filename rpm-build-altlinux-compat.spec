#TODO: port rpm-utils?
%if %{_vendor} != "alt"
# ALT has it in RPM
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

Name: rpm-build-altlinux-compat
Version: 0.3
Release: %{_vendor}1

Summary: ALT Linux compatibility in rpm build on other platforms

License: GPL
Group: Development/Other
Url: http://wiki.sisyphus.ru/devel/rpmbuildaltlinuxcompact

Packager: Vitaly Lipatov <lav@altlinux.ru>

Source: http://etersoft.ru/download/%name-%version.tar.bz2

BuildArchitectures: noarch

%if %{_vendor} != "suse"
Requires: rpm-build
%endif

%description
This package contains ALT Linux compatibility layer for rpm build
on other rpm-based platforms.

%prep
%setup
find -type d -name CVS | xargs rm -rf
%install
#%if %{_vendor} == "RPM"
#rm -rf $RPM_BUILD_ROOT
#%endif

DESTFILE=macros
# ALT: /etc/rpm/macros.d
# RHEL: /etc/rpm/macros.name
%if %{_vendor} == "redhat"
DESTFILE=macros.%name
%endif

# suse asplinux RPM: macros

%__install -D -m644 rpm/macros %buildroot/etc/rpm/$DESTFILE
%__mkdir -p %buildroot%_bindir
%__install -m755 bin/* %buildroot%_bindir

%files
%doc AUTHORS TODO NEWS
%_bindir/*
/etc/rpm/*

%changelog
* Fri Dec 30 2005 Vitaly Lipatov <lav@altlinux.ru> 0.3-alt1
- new release, macros updated by Denis Smirnov

* Sat Oct 29 2005 Vitaly Lipatov <lav@altlinux.ru> 0.1-redhat1
- test pre release
