//
//  MulleObjCConcreteMutableData.m
//  MulleObjCFoundation
//
//  Created by Nat! on 01.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteMutableData.h"


@implementation _MulleObjCConcreteMutableData


- (id) initWithCapacity:(NSUInteger) capacity
{
   mulle_buffer_set_allocator( &_storage, MulleObjCAllocator());
   mulle_buffer_set_initial_capacity( &_storage, capacity);
   return( self);
}


+ (id) dataWithCapacity:(NSUInteger) capacity
{
   return( [[[self alloc] initWithCapacity:capacity] autorelease]);
}


- (id) initWithBytes:(void *) buf
              length:(NSUInteger) length
{  
   mulle_buffer_set_initial_capacity( &_storage, length);
   mulle_buffer_set_allocator( &_storage, MulleObjCAllocator());
   
   mulle_buffer_add_bytes( &_storage, buf, length);
   return( self);
}

- (void) appendBytes:(void *) buf 
              length:(NSUInteger) length
{
   mulle_buffer_add_bytes( &_storage, buf, length);
}


- (void) appendData:(NSData *) otherData
{
   mulle_buffer_add_bytes( &_storage, [otherData bytes], [otherData length]);
}


- (void) increaseLengthBy:(NSUInteger) extraLength
{  
   mulle_buffer_memset( &_storage, 0, extraLength);
}


- (void *) bytes
{
   return( mulle_buffer_get_bytes( &_storage));
}


- (void *) mutableBytes
{
   return( mulle_buffer_get_bytes( &_storage));
}


static void   *validated_range_pointer( _MulleObjCConcreteMutableData *self, NSRange range)
{
   unsigned char  *p;
   NSUInteger     len;
   size_t         buf_len;
   
   p       = mulle_buffer_get_bytes( &self->_storage);
   len     = range.location + range.length;
   buf_len = mulle_buffer_get_length( &self->_storage);
   if( len > buf_len)
      MulleObjCThrowInvalidRangeException( range);
   return( p);
}


- (void) replaceBytesInRange:(NSRange) range 
                   withBytes:(void *) bytes 
                      length:(NSUInteger) len
{
   void  *p;

   if( len != range.length)
   {
      if( len > range.length)
      {
         // grow
         abort();
      }
      else
      {
         // shrink
         abort();
      }
   }
   
   p = validated_range_pointer( self, range);
   memcpy( p, bytes, range.length);
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

- (NSUInteger) length
{
   return( mulle_buffer_get_length( &_storage));
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


- (void) setLengthDontZero:(NSUInteger) length
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
