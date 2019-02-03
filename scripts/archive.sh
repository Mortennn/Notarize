#!/bin/bash
PACKAGE_NAME=${EXECUTABLE_NAME:?}
TMP=$(mktemp -d)/$PACKAGE_NAME
BINDIR=$TMP/bin
ZIPFILE=$TMP/${EXECUTABLE_NAME:?}.zip
INSTALLSH=scripts/install.sh
LICENSE=LICENSE

# copy

mkdir -p $BINDIR
cp -f .build/release/$EXECUTABLE_NAME $BINDIR

cp $INSTALLSH $TMP

cp $LICENSE $TMP

# zip

(cd $TMP/..; zip -r $ZIPFILE $PACKAGE_NAME)

# print sha

SHA=$(cat $ZIPFILE | shasum -a 256 | sed 's/ .*//')
echo "SHA: $SHA"
mv $ZIPFILE .A

# cleanup

rm -rf $TMP

