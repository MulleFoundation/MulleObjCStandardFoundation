# -- Formula Info --
# If you don't have this file, there will be no homebrew
# formula operations.
#
PROJECT="Bin"   # your project name, requires camel-case
DESC="Bin is ..."
# LANGUAGE="c"        # c,cpp, objc, bash ...


#
# Specify needed homebrew packages by name as you would when saying
# `brew install`.
#
# Use the ${DEPENDENCY_TAP} prefix for non-official dependencies.
# DEPENDENCIES and BUILD_DEPENDENCIES will be evaled later! 
# So keep them single quoted.
#
# DEPENDENCIES='${DEPENDENCY_TAP}mulle-concurrent
# libpng
# '

#
# Build via mulle-build. If you don't like this
# edit bin/release.sh
#
BUILD_DEPENDENCIES='${BOOTSTRAP_TAP}mulle-build
cmake'


# Uncomment this if you don't want to push the formula
# OPTION_NO_TAP_PUSH="YES"
