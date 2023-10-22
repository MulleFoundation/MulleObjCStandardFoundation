/*
 *   This file will be regenerated by `mulle-project-versioncheck`.
 *   Any edits will be lost.
 */
#ifndef mulle_objc_standard_foundation_versioncheck_h__
#define mulle_objc_standard_foundation_versioncheck_h__

#if defined( MULLE_OBJC_CONTAINER_FOUNDATION_VERSION)
# ifndef MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MIN
#  define MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MIN  ((0 << 20) | (22 << 8) | 0)
# endif
# ifndef MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MAX
#  define MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MAX  ((0 << 20) | (23 << 8) | 0)
# endif
# if MULLE_OBJC_CONTAINER_FOUNDATION_VERSION < MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MIN
#  error "MulleObjCContainerFoundation is too old"
# endif
# if MULLE_OBJC_CONTAINER_FOUNDATION_VERSION >= MULLE_OBJC_CONTAINER_FOUNDATION_VERSION_MAX
#  error "MulleObjCContainerFoundation is too new"
# endif
#endif

#if defined( MULLE_OBJC_TIME_FOUNDATION_VERSION)
# ifndef MULLE_OBJC_TIME_FOUNDATION_VERSION_MIN
#  define MULLE_OBJC_TIME_FOUNDATION_VERSION_MIN  ((0 << 20) | (1 << 8) | 2)
# endif
# ifndef MULLE_OBJC_TIME_FOUNDATION_VERSION_MAX
#  define MULLE_OBJC_TIME_FOUNDATION_VERSION_MAX  ((0 << 20) | (2 << 8) | 0)
# endif
# if MULLE_OBJC_TIME_FOUNDATION_VERSION < MULLE_OBJC_TIME_FOUNDATION_VERSION_MIN
#  error "MulleObjCTimeFoundation is too old"
# endif
# if MULLE_OBJC_TIME_FOUNDATION_VERSION >= MULLE_OBJC_TIME_FOUNDATION_VERSION_MAX
#  error "MulleObjCTimeFoundation is too new"
# endif
#endif

#if defined( MULLE_OBJC_VALUE_FOUNDATION_VERSION)
# ifndef MULLE_OBJC_VALUE_FOUNDATION_VERSION_MIN
#  define MULLE_OBJC_VALUE_FOUNDATION_VERSION_MIN  ((0 << 20) | (22 << 8) | 0)
# endif
# ifndef MULLE_OBJC_VALUE_FOUNDATION_VERSION_MAX
#  define MULLE_OBJC_VALUE_FOUNDATION_VERSION_MAX  ((0 << 20) | (23 << 8) | 0)
# endif
# if MULLE_OBJC_VALUE_FOUNDATION_VERSION < MULLE_OBJC_VALUE_FOUNDATION_VERSION_MIN
#  error "MulleObjCValueFoundation is too old"
# endif
# if MULLE_OBJC_VALUE_FOUNDATION_VERSION >= MULLE_OBJC_VALUE_FOUNDATION_VERSION_MAX
#  error "MulleObjCValueFoundation is too new"
# endif
#endif

#endif
