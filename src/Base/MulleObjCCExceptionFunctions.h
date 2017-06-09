//
//  MulleObjCCBaseFunctions.h
//  MulleObjCFoundation
//
//  Created by Nat! on 29.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#ifndef _NSCExceptionFunctions_h__
#define _NSCExceptionFunctions_h__

#include <MulleObjC/ns_int_type.h>
#include <MulleObjC/ns_range.h>


__attribute__ ((noreturn))
static inline void   MulleObjCThrowCInvalidArgumentException( char *format, ...)
{
   va_list  args;

   va_start( args, format);
   mulle_objc_throw_invalid_argument_exception_v( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowCInternalInconsistencyException( char *format, ...)
{
   va_list  args;

   va_start( args, format);
   mulle_objc_throw_internal_inconsistency_exception_v( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
static inline void   MulleObjCThrowCErrnoException( char *format, ...)
{
   va_list  args;

   va_start( args, format);
   mulle_objc_throw_errno_exception_v( format, args);
   va_end( args);
}

#endif
