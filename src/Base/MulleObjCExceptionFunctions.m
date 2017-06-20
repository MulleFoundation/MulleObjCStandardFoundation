//
//  MulleObjCBaseFunctions.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "MulleObjCExceptionFunctions.h"

// other files in this library
#include "ns_foundationconfiguration.h"

// other libraries of MulleObjCStandardFoundation

// std-c and other dependencies


// Exception

static struct _ns_exceptionhandlertable *MulleObjCExceptionHandlersUnfailingGetTable()
{
   struct _ns_exceptionhandlertable   *vectors;

   vectors = &_ns_get_rootconfiguration()->exception.vectors;
   if( ! vectors)
   {
      fprintf( stderr, "Exception vector table not installed yet! Exception output suppressed.\n");
      exit( 1);
   }
   return( vectors);
}


__attribute__ ((noreturn))
void   MulleObjCThrowAllocationException( size_t bytes)
{
   MulleObjCExceptionHandlersUnfailingGetTable()->allocation_error( bytes);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidArgumentException( NSString *format, ...)
{
   va_list   args;

   va_start( args, format);
   MulleObjCExceptionHandlersUnfailingGetTable()->invalid_argument( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidIndexException( NSUInteger index)
{
   MulleObjCExceptionHandlersUnfailingGetTable()->invalid_index( index);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInternalInconsistencyException( NSString *format, ...)
{
   va_list   args;

   va_start( args, format);
   MulleObjCExceptionHandlersUnfailingGetTable()->internal_inconsistency( format, args);
   va_end( args);
}


__attribute__ ((noreturn))
void   MulleObjCThrowInvalidRangeException( NSRange range)
{
   MulleObjCExceptionHandlersUnfailingGetTable()->invalid_range( range);
}


__attribute__ ((noreturn))
void   MulleObjCThrowErrnoException( NSString *format, ...)
{
   va_list  args;

   va_start( args, format);

   MulleObjCExceptionHandlersUnfailingGetTable()->errno_error( format, args);
   va_end( args);
}

