#TODO: port rpm-utils?
%if %{_vendor} != "alt"
# 
# ALT has it in RPM
BuildRoot: %{_tmppath}/%{name}-%{version}
%endif

Name: rpm-build-altlinux-compat
Version: 0.2
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

%install
#%if %{_vendor} == "RPM"
#rm -rf $RPM_BUILD_ROOT
#%endif

# ALT: /etc/rpm/macros.d
# RHEL: /etc/rpm/macros.name
DESTFILE=macros.%name

%if %{_vendor} == "suse"
DESTFILE=macros
%endif

%if %{_vendor} == "asplinux"
DESTFILE=macros
%endif

%if %{_vendor} == "RPM"
DESTFILE=macros
%endif

%__install -D -m644 rpm/macros %buildroot%_sysconfdir/rpm/$DESTFILE
%__mkdir -p %buildroot%_bindir
%__install -m755 bin/* %buildroot%_bindir

%files
%doc AUTHORS TODO NEWS
%_bindir/*
%if %{_vendor} == "suse"
%exclude %_bindir/subst
%endif
%_sysconfdir/rpm/*

%changelog
* Sat Oct 29 2005 Vitaly Lipatov <lav@altlinux.ru> 0.1-redhat1
- test pre release
