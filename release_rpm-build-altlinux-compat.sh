#!/bin/sh
# Release script for small projects packaged in RPM
# Use etersoft-build-utils as helper
. /etc/rpm/etersoft-build-functions


NAME=$(basename `pwd`)
SPECNAME=$NAME.spec
build_rpms_name $SPECNAME
TARNAME=$NAME-$VERSION.tar.bz2

# Usual path to public sources
PUBLICSERVER=etersoft
# FIXME: ~ is local home
PUBLICPATH=~/download/$NAME

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
	tar cfj $TARNAME $NAME-$VERSION/* || fatal_error "Can't create tarball"
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

if [ $STEP -le 5 ]; then
	echo "Step 5"
	rpmbs $SPECNAME
	cp $RPMDIR/SRPMS/$NAMESRPMIN $BUILDHOME/tmp
	exit 1
fi

if [ $STEP -le 6 ]; then
	echo "Step 6"
	rsync --progress ../$TARNAME $PUBLICSERVER:$PUBLICPATH/$TARNAME || fatal_error "Can't rsync"
	ssh $PUBLICSERVER ln -sf $TARNAME $PUBLICPATH/$NAME-current.tar.bz2
	#UDIR=$UPLOADDIR/../upload_alt_ftp/natspec
	#rsync --progress $TARNAME $UDIR || exit 1
	#rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* $UDIR/ \
	#	&& cd $UPLOADDIR/.. && ./upload-to-alt-ftp
	#ftp.alt:/ftp/pub/people/lav/natspec
	
	#rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* ~/tmp/
fi

if [ $STEP -le 7 ]; then
	echo "Step 7"
	scp $RPMDIR/SRPMS/$NAMESRPMIN office:~/tmp/
fi
