//
//  _MulleObjCConcreteMutableData.m
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

#import "_MulleObjCConcreteMutableData.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCConcreteMutableData


static void   append_via_tmp_buffer( _MulleObjCConcreteMutableData *self, void *bytes, NSUInteger length)
{
   void   *tmp;

   tmp = mulle_malloc( length);
   {
      memcpy( tmp, bytes, length);
      mulle_buffer_add_bytes( &self->_storage, tmp, length);
   }
   mulle_free( tmp);
}


static void   append_bytes( _MulleObjCConcreteMutableData *self, void *bytes, NSUInteger length)
{
   if( ! mulle_buffer_intersects_bytes( &self->_storage, bytes, length))
   {
      mulle_buffer_add_bytes( &self->_storage, bytes, length);
      return;
   }

   append_via_tmp_buffer( self, bytes, length);
}


+ (instancetype) newWithCapacity:(NSUInteger) capacity
{
   _MulleObjCConcreteMutableData   *data;
   struct mulle_allocator          *allocator;


   data = NSAllocateObject( self, 0, NULL);

   allocator = MulleObjCObjectGetAllocator( data);
   mulle_buffer_init_with_capacity( &data->_storage, capacity, allocator);

   return( data);
}


+ (instancetype) newWithLength:(NSUInteger) length
{
   _MulleObjCConcreteMutableData   *data;
   struct mulle_allocator          *allocator;


   data = NSAllocateObject( self, 0, NULL);

   allocator = MulleObjCObjectGetAllocator( data);
   mulle_buffer_init_with_capacity( &data->_storage, length, allocator);
   mulle_buffer_set_length( &data->_storage, length);

   return( data);
}


+ (instancetype) newWithBytes:(void *) buf
                       length:(NSUInteger) length
{
   _MulleObjCConcreteMutableData   *data;
   struct mulle_allocator          *allocator;


   data = NSAllocateObject( self, 0, NULL);

   allocator = MulleObjCObjectGetAllocator( data);
   mulle_buffer_init_with_capacity( &data->_storage, length, allocator);
   append_bytes( data, buf, length);

   return( data);
}


+ (instancetype) newWithBytesNoCopy:(void *) bytes
                   length:(NSUInteger) length
                allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCConcreteMutableData   *data;

   data = NSAllocateObject( self, 0, NULL);

   mulle_buffer_init_with_allocated_bytes( &data->_storage, bytes, length, allocator);
   mulle_buffer_advance( &data->_storage, length);
   return( data);
}


- (void) dealloc
{
   mulle_buffer_done( &self->_storage);
   NSDeallocateObject( self);
}


#pragma mark -
#pragma mark accessors

- (void *) bytes
{
   // true to spec
   if( ! mulle_buffer_get_length( &_storage))
      return( NULL);
   return( mulle_buffer_get_bytes( &_storage));
}


- (void *) mutableBytes
{
   return( mulle_buffer_get_bytes( &_storage));
}


- (NSUInteger) length
{
   return( mulle_buffer_get_length( &_storage));
}


#pragma mark -
#pragma mark operations

- (void) appendBytes:(void *) bytes
              length:(NSUInteger) length
{
   append_bytes( self, bytes, length);
}


- (void) appendData:(NSData *) otherData
{
   append_bytes( self, [otherData bytes], [otherData length]);
}


- (void) increaseLengthBy:(NSUInteger) extraLength
{
   mulle_buffer_memset( &_storage, 0, extraLength);
}


static void   *validated_range_pointer( _MulleObjCConcreteMutableData *self, NSRange range)
{
   unsigned char  *p;
   NSUInteger     len;
   size_t         buf_len;

   p       = mulle_buffer_get_bytes( &self->_storage);
   len     = range.location + range.length;
   buf_len = mulle_buffer_get_length( &self->_storage);
   if( len > buf_len || range.length > buf_len)
      MulleObjCThrowInvalidRangeException( range);
   return( p);
}


- (void) replaceBytesInRange:(NSRange) range
                   withBytes:(void *) bytes
{
   void  *p;

   p = validated_range_pointer( self, range);
   memcpy( p, bytes, range.length);
}


- (void) resetBytesInRange:(NSRange) range
{
   void  *p;

   p = validated_range_pointer( self, range);
   memset( p, 0, range.length);
}


- (void) setLength:(NSUInteger) length
{
   NSUInteger   curr_length;

   curr_length = mulle_buffer_get_length( &_storage);
   if( length == curr_length)
      return;

   if( ! length)
   {
      mulle_buffer_reset( &_storage);
      return;
   }

   mulle_buffer_zero_to_length( &_storage, length);
}


- (void) _setLengthDontZero:(NSUInteger) length
{
   NSUInteger   curr_length;

   curr_length = mulle_buffer_get_length( &_storage);
   if( length == curr_length)
      return;

   if( ! length)
   {
      mulle_buffer_reset( &_storage);
      return;
   }

   mulle_buffer_set_length( &_storage, length);
}

@end
