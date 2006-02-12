#!/bin/sh
. /etc/rpm/etersoft-build-functions

NAME=rpm-build-altlinux-compat
STEP=1

SPECNAME=$NAME.spec
build_rpms_name $SPECNAME
TARNAME=$NAME-$VERSION.tar.bz2

cd ..
ln -s $NAME $NAME-$VERSION
tar cvfj $TARNAME $NAME-$VERSION
rm -f $NAME-$VERSION
cd -
exit 1

PUBLICPATH=etersoft:~/download/%NAME

ssh-add -l || ssh-add

if [ $STEP -le 1 ]; then
	echo "Step 1"
	cd $NAME-$VER
	cvs -z3 update -dPR || { echo ERROR; exit 1; }
	./autogen.sh
	rm -rf autom4te.cache
	cd -
	tar cvfj $TARNAME $NAME-$VER/* || exit 1
fi

if [ $STEP -le 2 ]; then
	echo "Step 2"
	cp -f $TARNAME $RPMDIR/SOURCES/
fi
#exit 1

if [ $STEP -le 3 ]; then
	echo "Step 3"
	scp $TARNAME cf.sf:~
fi
#exit 1

if [ $STEP -le 4 ]; then
	echo "Step 4"
	cd $NAME-$VER
	rpmbshr $SPECNAME 
	cd -
fi

if [ $STEP -le 5 ]; then
	echo "Step 5"
	pushd $NAME-$VER
	rpmbs -s $SPECNAME
	# && cd $UPLOADDIR/.. && ./upload-to-alt
	popd
fi

if [ $STEP -le 6 ]; then
	echo "Step 6"
	#ssh $BUILDSERVER ls $BUILDSERVERPATH/${NAME}-*${VER}-${REL}*
	rsync --progress $TARNAME $PUBLICPATH/$TARNAME || exit 1
	UDIR=$UPLOADDIR/../upload_alt_ftp/natspec
	rsync --progress $TARNAME $UDIR || exit 1
	#rm -rf $UDIR/libnatspec*
	rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* $UDIR/ \
		&& cd $UPLOADDIR/.. && ./upload-to-alt-ftp
	#ftp.alt:/ftp/pub/people/lav/natspec
	
	#rsync --progress $BUILDSERVER:$BUILDSERVERPATH/${NAME}-*${VER}-${REL}* ~/tmp/
fi
