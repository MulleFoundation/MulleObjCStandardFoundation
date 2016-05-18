#! /bin/sh

#
# use our mulle-configuration settings for all
# subrepos
#
CMAKE_MODULE_PATH="${PWD}/mulle-configuration"
export CMAKE_MODULE_PATH

mulle-bootstrap ${MULLE_BOOTSTRAP_FLAGS} build "$@" -c Debug -k

# xcodebuild -configuration Release -scheme Libraries
xcodebuild -configuration Debug -scheme Libraries
