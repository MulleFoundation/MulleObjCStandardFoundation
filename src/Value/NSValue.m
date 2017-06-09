//
//  NSValue.m
//  MulleObjCFoundation
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
#import "NSValue.h"

// other files in this library
#import "_MulleObjCConcreteValue.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <string.h>
#include <stdint.h>
#include <mulle_container/mulle_container.h>



#define MulleObjCValueAllocPlaceholderHash         0x331bd8f6291d398e  // MulleObjCValueAllocPlaceholder
#define MulleObjCValueInstantiatePlaceholderHash   0x56fb1f12fb5bee1f  // MulleObjCValueInstantiatePlaceholder



@implementation NSObject( _NSValue)

- (BOOL) __isNSValue
{
   return( NO);
}

@end


@implementation NSValue

- (BOOL) __isNSValue
{
   return( YES);
}


+ (mulle_objc_classid_t) __allocPlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCValueAllocPlaceholderHash));
}


+ (mulle_objc_classid_t) __instantiatePlaceholderClassid
{
   return( MULLE_OBJC_CLASSID( MulleObjCValueInstantiatePlaceholderHash));
}


#pragma mark -
#pragma mark classcluster ?

- (instancetype) initWithBytes:(void *) value
                      objCType:(char *) type
{
   [self release];
   return( [_MulleObjCConcreteValue newWithBytes:value
                                        objCType:type]);
}


#pragma mark -
#pragma mark convenience constructors

// compiler: need an @alias( alloc, whatever), so that implementations
//           can  be shared


+ (instancetype) value:(void *) bytes
withObjCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                              objCType:type] autorelease]);
}


+ (instancetype) valueWithBytes:(void *) bytes
             objCType:(char *) type
{
   return( [[[self alloc] initWithBytes:bytes
                              objCType:type] autorelease]);
}


+ (instancetype) valueWithPointer:(void *) pointer
{
   return( [[[self alloc] initWithBytes:&pointer
                               objCType:@encode( void *)] autorelease]);
}


+ (instancetype) valueWithRange:(NSRange) range
{
   return( [[[self alloc] initWithBytes:&range
                               objCType:@encode( NSRange)] autorelease]);
}


- (NSUInteger) _size
{
   NSUInteger   size;

   NSGetSizeAndAlignment( [self objCType], &size, NULL);
   return( size);
}

- (void) getValue:(void *) bytes
             size:(NSUInteger) size
{
   NSUInteger   real;

   NSGetSizeAndAlignment( [self objCType], &real, NULL);
   if( real != size)
      MulleObjCThrowInvalidArgumentException( @"size should be %ld bytes on this platform", real);

   [self getValue:bytes];
}


- (void *) pointerValue
{
   void  *pointer;

   [self getValue:&pointer
             size:sizeof( void *)];
   return( pointer);
}


- (NSRange) rangeValue
{
   NSRange  range;

   [self getValue:&range
             size:sizeof( NSRange)];
   return( range);
}

- (id) copy
{
   return( [self retain]);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   NSUInteger   size;

   NSGetSizeAndAlignment( [self objCType], &size, NULL);

   {
      char  bytes[ size];

      [self getValue:bytes];

      return( MulleObjCBytesPartialHash( bytes, size));
   }
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSValue])
      return( NO);
   return( [self isEqualToValue:other]);
}


- (BOOL) isEqualToValue:(NSValue *) other
{
   char        *type;
   char        *oType;
   NSUInteger   size;
   NSUInteger   otherSize;
   BOOL         flag;

   NSParameterAssert( [other isKindOfClass:[NSValue class]]);

   type  = [self objCType];
   oType = [other objCType];

   // should not compare adornments ?
   if( strcmp( type, oType))
      return( NO);

   NSGetSizeAndAlignment( type, &size, NULL);
   NSGetSizeAndAlignment( oType, &otherSize, NULL);

   if( size != otherSize)
      return( NO);

   {
      auto char   buf[ size];
      auto char   buf2[ size];

      [self getValue:&buf];
      [other getValue:&buf2];

      flag = ! memcmp( buf, buf2, size);
   }

   return( flag);
}

@end
