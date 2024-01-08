# This file will be regenerated by `mulle-match-to-cmake` via
# `mulle-sde reflect` and any edits will be lost.
#
# This file will be included by cmake/share/Headers.cmake
#
if( MULLE_TRACE_INCLUDE)
   MESSAGE( STATUS "# Include \"${CMAKE_CURRENT_LIST_FILE}\"" )
endif()

#
# contents are derived from the file locations

set( INCLUDE_DIRS
src
src/Container
src/Container/NSArray
src/Container/NSDictionary
src/Container/NSSet
src/Date
src/Exception
src/Locale
src/Notification
src/TimeZone
src/Undo
src/Value
src/generic
src/reflect
)

#
# contents selected with patternfile ??-header--private-generated-headers
#
set( PRIVATE_GENERATED_HEADERS
src/reflect/_MulleObjCStandardFoundation-import-private.h
src/reflect/_MulleObjCStandardFoundation-include-private.h
)

#
# contents selected with patternfile ??-header--private-generic-headers
#
set( PRIVATE_GENERIC_HEADERS
src/generic/import-private.h
src/generic/include-private.h
)

#
# contents selected with patternfile ??-header--private-headers
#
set( PRIVATE_HEADERS
src/TimeZone/_MulleGMTTimeZone-Private.h
src/mulle-foundation-startup-private.inc
src/mulle-foundation-universeconfiguration-private.h
)

#
# contents selected with patternfile ??-header--public-generated-headers
#
set( PUBLIC_GENERATED_HEADERS
src/reflect/_MulleObjCStandardFoundation-import.h
src/reflect/_MulleObjCStandardFoundation-include.h
)

#
# contents selected with patternfile ??-header--public-generic-headers
#
set( PUBLIC_GENERIC_HEADERS
src/generic/import.h
src/generic/include.h
)

#
# contents selected with patternfile ??-header--public-headers
#
set( PUBLIC_HEADERS
src/Container/MulleObjCContainerDescription.h
src/Container/MulleObjCContainerIntegerCallback.h
src/Container/MulleObjCContainerPointerCallback.h
src/Container/MulleObjCContainerSELCallback.h
src/Container/MulleObjCStandardContainerFoundation.h
src/Container/NSArray/NSArray+NSSortDescriptor.h
src/Container/NSArray/NSArray+NSString.h
src/Container/NSDictionary/NSMapTable+NSArray+NSString.h
src/Container/NSSet/NSHashTable+NSArray+NSString.h
src/Container/NSSet/NSSet+NSString.h
src/Container/NSSortDescriptor+NSCoder.h
src/Container/NSSortDescriptor.h
src/Date/_MulleObjCConcreteCalendarDate.h
src/Date/NSCalendarDate+NSDateFormatter.h
src/Date/NSCalendarDate.h
src/Date/NSDateFormatter.h
src/Date/NSDate+NSCalendarDate.h
src/Date/NSDate+NSDateFormatter.h
src/Date/mulle-mini-tm.h
src/Exception/MulleObjCStandardExceptionFoundation.h
src/Exception/NSAssertionHandler.h
src/Exception/NSError.h
src/Exception/NSException.h
src/Locale/MulleObjCStandardLocaleFoundation.h
src/Locale/NSArray+NSLocale.h
src/Locale/NSDictionary+NSLocale.h
src/Locale/NSLocale.h
src/Locale/NSNumberFormatter.h
src/Locale/NSNumber+NSLocale.h
src/Locale/NSScanner+NSLocale.h
src/Locale/NSString+NSLocale.h
src/MulleObjCFoundationCore.h
src/MulleObjCLoader+MulleObjCStandardFoundation.h
src/MulleObjCStandardFoundation.h
src/Notification/MulleObjCStandardNotificationFoundation.h
src/Notification/NSNotificationCenter.h
src/Notification/NSNotification.h
src/Notification/NSThread+NSNotification.h
src/TimeZone/NSDate+NSTimeZone.h
src/TimeZone/NSTimeZone.h
src/Undo/MulleObjCStandardUndoFoundation.h
src/Undo/NSUndoManager.h
src/Value/MulleObjCCharacterBitmap.h
src/Value/_MulleObjCCheatingASCIICharacterSet.h
src/Value/_MulleObjCConcreteBitmapCharacterSet.h
src/Value/_MulleObjCConcreteCharacterSet.h
src/Value/_MulleObjCConcreteInvertedCharacterSet.h
src/Value/_MulleObjCConcreteRangeCharacterSet.h
src/Value/MulleObjCStandardValueFoundation.h
src/Value/NSArray+StringComponents.h
src/Value/NSCharacterSet.h
src/Value/NSData+Components.h
src/Value/NSFormatter.h
src/Value/NSMutableCharacterSet.h
src/Value/NSMutableString+Search.h
src/Value/NSScanner.h
src/Value/NSString+Components.h
src/Value/NSString+DoubleQuotes.h
src/Value/NSString+Escaping.h
src/Value/NSString+NSCharacterSet.h
src/Value/NSString+Search.h
src/reflect/_MulleObjCStandardFoundation-versioncheck.h
)

