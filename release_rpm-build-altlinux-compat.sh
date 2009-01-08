#!/bin/sh
# Author: Vitaly Lipatov <lav@etersoft.ru>
# 2006, Public domain
# Release script for small projects packaged in RPM
# Use etersoft-build-utils as helper

# if [ -r /usr/share/eterbuild/korinf ]
. /etc/rpm/etersoft-build-functions

ALPHA=/unstable
if [ "$1" = "-r" ] ; then
	ALPHA=/$2
	shift 2
fi

check_key

update_from_cvs

prepare_tarball

rpmbb $SPECNAME || fatal "Can't build"

if [ "$WINEPUB_PATH" ] ; then
	# Path to local publishing
	ETERDESTSRPM=$WINEPUB_PATH$ALPHA/sources
	publish_srpm -z
fi

# Usual path to public sources
# scp $TARNAME cf.sf:~   (use below params for it)
#PUBLICSERVER=etersoft
#PUBLICPATH=/home/lav/download/$BASENAME

#publish_tarball

