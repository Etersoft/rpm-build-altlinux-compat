#!/bin/sh
# Release script for small projects packaged in RPM
# Use etersoft-build-utils as helper
. /etc/rpm/etersoft-build-functions

NAME=rpm-build-altlinux-compat
PUBLICPATH=etersoft:~/download/$NAME

SPECNAME=$NAME.spec
build_rpms_name $SPECNAME
TARNAME=$NAME-$VERSION.tar.bz2

STEP=2

# Update from CVS
if [ $STEP -le 1 ]; then
	if [ -d CVS ] ; then
		cvs -z3 update -dPR || fatal_error "Can't update from CVS..."
	fi
fi

# Make tarball
if [ $STEP -le 2 ]; then
	cd ..
	ln -s $NAME $NAME-$VERSION
	tar cvfj $TARNAME $NAME-$VERSION/* || fatal_error "Can't create tarball"
	rm -f $NAME-$VERSION
	cd -
fi

check_key


if [ $STEP -le 3 ]; then
	echo "Step 3"
	cp -f ../$TARNAME $RPMDIR/SOURCES/
fi

#if [ $STEP -le 3 ]; then
#	echo "Step 3"
#	scp $TARNAME cf.sf:~
#fi
#exit 1

if [ $STEP -le 4 ]; then
	echo "Step 4"
	rpmbb $SPECNAME 
fi

#if [ $STEP -le 5 ]; then
#	echo "Step 5"
#	rpmbs -s $SPECNAME
#fi

if [ $STEP -le 6 ]; then
	echo "Step 6"
	rsync --progress ../$TARNAME $PUBLICPATH/$TARNAME || fatal_error "Can't rsync"
	#UDIR=$UPLOADDIR/../upload_alt_ftp/natspec
	#rsync --progress $TARNAME $UDIR || exit 1
	#rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* $UDIR/ \
	#	&& cd $UPLOADDIR/.. && ./upload-to-alt-ftp
	#ftp.alt:/ftp/pub/people/lav/natspec
	
	#rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* ~/tmp/
fi
