#!/bin/sh
# Author: Vitaly Lipatov <lav@etersoft.ru>
# 2006, Public domain
# Release script for small projects packaged in RPM
# Use etersoft-build-utils as helper
. /etc/rpm/etersoft-build-functions

WORKDIR=/home/builder/Projects/eterbuild/functions

test -f $WORKDIR/config.in && . $WORKDIR/config.in

ALPHA=/current
if [ "$1" = "-r" ] ; then
	if [ -z "$2" ] ; then
		ALPHA=/$WINENUMVERSION
	else
		ALPHA=/$2
		shift
	fi
	shift
fi

check_key

update_from_cvs

prepare_tarball

rpmbb $SPECNAME || fatal "Can't build"

if [ "$WINEPUB_PATH" ] ; then
	# Path to local publishing
	ETERDESTSRPM=$WINEPUB_PATH$ALPHA/sources
	publish_srpm -z -s
fi

# Usual path to public sources
# scp $TARNAME cf.sf:~   (use below params for it)
PUBLICSERVER=etersoft
PUBLICPATH=/home/lav/download/$BASENAME

publish_tarball

