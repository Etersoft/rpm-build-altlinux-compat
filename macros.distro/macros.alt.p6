# Platform and version dependend macros
# These macros will packed in rpm-build-compat package on ALT

# _sharedstatedir is broken on ALTLinux p6 and early
# https://bugzilla.redhat.com/show_bug.cgi?id=185862
%_sharedstatedir /var/lib

# path to /etc/sudoers extension dir
%_sudoersdir %_sysconfdir/sudoers.d

# since rpm-macros-cmake-2.8.8-alt1
%cmake_build \
    %make_build -C BUILD

%cmake_install \
    %make_install -C BUILD

%cmakeinstall_std \
    %makeinstall_std -C BUILD
