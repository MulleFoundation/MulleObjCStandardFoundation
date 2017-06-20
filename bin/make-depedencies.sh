#! /bin/sh


# only runs on OS X out of the box


#
# get path for mulle-objc-list
#
eval `mulle-bootstrap paths path`

DEPENDENCIES="`mulle-bootstrap paths dependencies`"

if [ ! -f "${DEPENDENCIES}/lib/libMulleObjCStandalone.dylib" ]
then
   echo "${DEPENDENCIES}/lib/libMulleObjCStandalone.dylib not found, mulle-bootstrap first" >&2
   exit 1
fi

if [ ! -f "build/libMulleObjCFoundationStandalone.dylib" ]
then
   echo "build/libMulleObjCFoundationStandalone.dylib not found, mulle-build first" >&2
   exit 1
fi

#
# First get all classes and categories "below" OS for later removal
# Then get all standalone classes, but remove Posix classes and
# OS specifica. The remainder are osbase-dependencies
#
mulle-objc-list -d "${DEPENDENCIES}/lib/libMulleObjCStandalone.dylib" > /tmp/minus.inc || exit 1
mulle-objc-list -d "build/libMulleObjCFoundationStandalone.dylib" > /tmp/plus.inc || exit 1
fgrep -x -v -f/tmp/minus.inc /tmp/plus.inc > src/dependencies.inc || exit 1

echo "src/dependencies.inc written" >&2
exit 0
