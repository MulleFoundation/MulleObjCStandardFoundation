//
//  _MulleObjCDataSubclasses.m
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
#import "_MulleObjCDataSubclasses.h"



@implementation _MulleObjCConcreteData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCZeroBytesData   *data;

   data = NSAllocateObject( self, 0, NULL);
   return( data);
}

static inline void   *get_bytes( id self)
{
   return( self);
}

- (void *) bytes
{
   return( get_bytes( self));
}

- (void) dealloc
{
   NSDeallocateObject( self);
}

@end


@implementation _MulleObjCZeroBytesData  // same as NSData really 
@end


@implementation _MulleObjCEightBytesData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCEightBytesData   *data;
   
   data = NSAllocateObject( self, 8, NULL);
   memcpy( get_bytes( data), bytes, 8);
   return( data);
}

- (NSUInteger) length { return( 8); }

@end


@implementation _MulleObjCSixteenBytesData

+ (id) newWithBytes:(void *) bytes
{
   _MulleObjCSixteenBytesData   *data;
   
   data = NSAllocateObject( self, 16, NULL);
   memcpy( get_bytes( data), bytes, 16);
   return( data);
}

- (NSUInteger) length { return( 16); }

@end


@implementation _MulleObjCAllocatorData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCAllocatorData   *data;
   
   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = MulleObjCObjectAllocateNonZeroedMemory( self, length);
   data->_length    = length;
   data->_allocator = MulleObjCClassGetAllocator( self);

   memcpy( data->_storage, bytes, length);

   return( data);
}


+ (id) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorData   *data;
   
   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = bytes;
   data->_length    = length;
   data->_allocator = allocator;
   
   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length);
}


- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   NSDeallocateObject( self);
}

@end



@implementation _MulleObjCSharedData

+ (id) newWithBytesNoCopy:(void *) bytes
                       length:(NSUInteger) length
                        owner:(id) owner
{
   _MulleObjCSharedData   *data;
   
   data = [self newWithBytesNoCopy:bytes
                                length:length
                             allocator:NULL];
   data->_other = [owner retain];

   return( data);
}


- (void) dealloc
{
   [_other release];
   [super dealloc];
}

@end


@implementation _MulleObjCTinyData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCTinyData   *data;
   NSUInteger            extra;
   
   assert( length >= 1 && length <= 256);
   
   extra = length > 3 ? length - 3 : 0;

   data = NSAllocateObject( self, extra, NULL);
   memcpy( data->_storage, bytes, length);
   data->_length = (unsigned char) (length - 1);

   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length + 1);
}

@end


@implementation _MulleObjCMediumData

+ (id) newWithBytes:(void *) bytes
             length:(NSUInteger) length
{
   _MulleObjCMediumData   *data;
   
   assert( length >= 0x101 && length <= 0x10100);
   
   data = NSAllocateObject( self, length - 2, NULL);

   memcpy( data->_storage, bytes, length);
   data->_length = (uint16_t) (length - 0x100 - 1);
   
   return( data);
}


- (void *) bytes
{
   return( _storage);
}


- (NSUInteger) length
{
   return( _length + 0x100 + 1);
}

@end
