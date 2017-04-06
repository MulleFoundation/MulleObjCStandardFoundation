//
//  _MulleObjCConcreteValue.m
//  MulleObjCFoundation
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

#import "_MulleObjCConcreteValue.h"
#import "_MulleObjCConcreteValue+Private.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <string.h>


@implementation _MulleObjCConcreteValue

+ (id) newWithBytes:(void *) bytes
           objCType:(char *) type
{
   _MulleObjCConcreteValue   *value;
   NSUInteger                extra;
   NSUInteger                size;
   size_t                    type_size;

   NSParameterAssert( type && strlen( type));
   NSParameterAssert( bytes);
   assert( bytes); // for analyzer
   assert( type && strlen( type)); // for analyzer

   NSGetSizeAndAlignment( type, &size, NULL);

   NSParameterAssert( size);

   type_size = strlen( type) + 1;
   extra     = size + type_size;

   value = NSAllocateObject( self, extra, NULL);

   value->_size = size;
   memcpy( _MulleObjCConcreteValueBytes( value), bytes, size);
   memcpy( _MulleObjCConcreteValueObjCType( value), type, type_size);

   return( value);
}


- (char *) objCType
{
   return( _MulleObjCConcreteValueObjCType( self));
}


- (NSUInteger) hash
{
   return( mulle_hash( _MulleObjCConcreteValueBytes( self), _size));
}


- (void) getValue:(void *) bytes
{
   memcpy( bytes, _MulleObjCConcreteValueBytes( self), _size);
}


- (void) getValue:(void *) bytes
             size:(NSUInteger) size
{
   if( size != _size)
      MulleObjCThrowInvalidArgumentException( @"size should be %ld bytes on this platform", _size);

   memcpy( bytes, _MulleObjCConcreteValueBytes( self), _size);
}

@end
