//
//  NSException.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSException.h"

// other files in this library
#import "NSAssertionHandler.h"


// private stuff from MulleObjC
#import <MulleObjC/mulle-objc-universefoundationinfo-private.h>

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardValueFoundation.h"

// std-c and dependencies

#pragma clang diagnostic ignored "-Winvalid-noreturn"

NSString  *NSGenericException               = @"NSGenericException";
NSString  *NSIndexException                 = @"NSIndexException";
NSString  *NSInternalInconsistencyException = @"NSInternalInconsistencyException";
NSString  *NSInvalidArgumentException       = @"NSInvalidArgumentException";
NSString  *NSMallocException                = @"NSMallocException";
NSString  *NSParseErrorException            = @"NSParseErrorException";
NSString  *NSRangeException                 = @"NSRangeException";

NSString  *MulleObjCErrnoException          = @"MulleObjCErrnoException";


@implementation NSException


__attribute__ ((noreturn))
static void   _throw_errno_exception( NSString *exceptionName,
                                      id format,
                                      va_list args)
{
   NSString  *s;

   s = [NSString mulleStringWithFormat:format
                             arguments:args];
   [NSException raise:exceptionName
               format:@"%@: %s", s, strerror( errno)];
}


__attribute__ ((noreturn))
static void   throw_errno_exception( id format,
                                     va_list args)
{
   _throw_errno_exception( MulleObjCErrnoException, format, args);
}


__attribute__ ((noreturn))
static void   throw_inconsistency_exception( id format, va_list args)
{
   [NSException raise:NSInternalInconsistencyException
               format:format
           arguments:args];
}


__attribute__ ((noreturn))
static void   throw_argument_exception( id format, va_list args)
{
   [NSException raise:NSInvalidArgumentException
               format:format
            arguments:args];
}


__attribute__ ((noreturn))
static void   throw_index_exception( NSUInteger index)
{
   [NSException raise:NSIndexException
               format:@"index %lu is out of range", (long) index];
}


__attribute__ ((noreturn))
static void   throw_range_exception( NSRange arg)
{
   [NSException raise:NSRangeException
               format:@"range %lu/%lu doesn't fit", (long) arg.location, (long) arg.length];
}



__attribute__ ((noreturn))
static void   throw_malloc_exception( void *block, size_t size)
{
   //
   // this could be foolhardy, if we are really out of memory, because
   // the exception will surely malloc something
   //
   if( ! block)
      [NSException raise:NSMallocException
                  format:@"could not allocate %lu bytes", (unsigned long) size];
   else
      [NSException raise:NSMallocException
                  format:@"could not reallocate %lu bytes for block %p", (unsigned long) size, block];
}


//
// for the benefit of MulleObjC vector their exceptions to us
//
void  _MulleObjCExceptionInitTable( struct _mulle_objc_exceptionhandlertable *table);
void  _MulleObjCExceptionInitTable( struct _mulle_objc_exceptionhandlertable *table)
{
   table->errno_error            = throw_errno_exception;
   table->invalid_argument       = throw_argument_exception;
   table->internal_inconsistency = throw_inconsistency_exception;
   table->invalid_index          = throw_index_exception;
   table->invalid_range          = throw_range_exception;
}


// maybe too late here... the foundation initializer should do this
+ (void) initialize
{
   struct _mulle_objc_exceptionhandlertable   *table;
   struct _mulle_objc_universe                *universe;
   static int                                 flag;

   if( ! flag)
   {
      universe = MulleObjCObjectGetUniverse( self);
      table    = mulle_objc_universe_get_foundationexceptionhandlertable( universe);
      _MulleObjCExceptionInitTable( table);
      flag     = YES;
   }
}



# pragma mark - conveniences

+ (void) raise:(NSString *) name
        format:(NSString *) format, ...
 {
   mulle_vararg_list   args;

   mulle_vararg_start( args, format);
   [self raise:name
        format:format
 mulleVarargList:args];
   mulle_vararg_end( args);
}


+ (void) raise:(NSString *) name
        format:(NSString *) format
     arguments:(va_list) args
{
   NSException   *exception;
   NSString      *reason;

   reason    = [NSString mulleStringWithFormat:format
                                     arguments:args];
   exception = [self exceptionWithName:name
                                reason:reason
                              userInfo:nil];

   [exception raise];
}


+ (void) raise:(NSString *) name
        format:(NSString *) format
mulleVarargList:(mulle_vararg_list) arguments
{
   NSException   *exception;
   NSString      *reason;

   reason    = [NSString stringWithFormat:format
                          mulleVarargList:arguments];
   exception = [self exceptionWithName:name
                                reason:reason
                              userInfo:nil];

   [exception raise];
}

# pragma mark - init/dealloc

+ (NSException *) exceptionWithName:(NSString *) name
                             reason:(NSString *) reason
                           userInfo:(NSDictionary *) userInfo
{
   return( [[[self alloc] initWithName:name
                                reason:reason
                              userInfo:userInfo] autorelease]);
}


- (instancetype) initWithName:(NSString *) name
                       reason:(NSString *) reason
                     userInfo:(NSDictionary *) userInfo
{
   NSParameterAssert( ! reason || [reason isKindOfClass:[NSString class]]);

   if( ! name)
   {
      [self release];
      MulleObjCThrowInvalidArgumentException( @"name can not be nil");
   }

   _name     = [name copy];
   _reason   = [reason copy];
   _userInfo = [userInfo retain];

   return( self);
}


- (void) dealloc
{
   [_name release];
   [_reason release];
   [_userInfo release];

   [super dealloc];
}


# pragma mark - petty accessors

- (NSString *) name
{
   return( _name);
}


- (NSString *) reason
{
   return( _reason);
}


- (id) userInfo
{
   return( _userInfo);
}

@end


// not vectored
MULLE_C_NO_RETURN
void   MulleObjCThrowMallocException( struct mulle_allocator *allocator,
                                      void *block,
                                      size_t size)
{
   throw_malloc_exception( block, size);
}


