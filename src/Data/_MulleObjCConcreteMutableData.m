//
//  MulleObjCConcreteMutableData.m
//  MulleObjCFoundation
//
//  Created by Nat! on 01.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteMutableData.h"


@implementation _MulleObjCConcreteMutableData


static void   append_via_tmp_buffer( _MulleObjCConcreteMutableData *self, void *bytes, NSUInteger length)
{
   struct mulle_allocator  *allocator;
   void                    *tmp;

   allocator = MulleObjCObjectGetAllocator( self);

   tmp = mulle_allocator_malloc( allocator, length);
   {
      memcpy( tmp, bytes, length);
      mulle_buffer_add_bytes( &self->_storage, tmp, length);
   }
   mulle_allocator_free( allocator, tmp);
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
   
   allocator = MulleObjCObjectGetAllocator( self);

   data = NSAllocateObject( self, 0, NULL);
   mulle_buffer_init_with_capacity( &data->_storage, capacity, allocator);

   return( data);
}


+ (instancetype) newWithLength:(NSUInteger) length
{
   _MulleObjCConcreteMutableData   *data;
   struct mulle_allocator          *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);

   data = NSAllocateObject( self, 0, NULL);
   
   mulle_buffer_init_with_capacity( &data->_storage, length, allocator);
   mulle_buffer_set_length( &data->_storage, length);

   return( data);
}


+ (instancetype) newWithBytes:(void *) buf
                       length:(NSUInteger) length
{  
   _MulleObjCConcreteMutableData   *data;
   struct mulle_allocator          *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);
   
   data = NSAllocateObject( self, 0, NULL);

   mulle_buffer_init_with_capacity( &data->_storage, length, allocator);
   append_bytes( data, buf, length);

   return( data);
}


+ (id) newWithBytesNoCopy:(void *) bytes
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
