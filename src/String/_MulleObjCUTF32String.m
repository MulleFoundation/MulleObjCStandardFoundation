//
//  MulleObjCUTF32String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCUTF32String.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <mulle_container/mulle_container.h>


@implementation _MulleObjCUTF32String

- (mulle_utf32_t *) _fastUTF32StringContents;
{
   return( NULL);
}


- (mulle_utf8_t *) _fastUTF8StringContents;
{
   return( NULL);
}


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) _UTF32StringLength
{
   return( _length);
}


- (NSUInteger) _UTF8StringLength
{
   return( mulle_utf32_length_as_utf8( [self _fastUTF32StringContents], _length));
}


- (mulle_utf8_t *) UTF8String
{
   struct mulle_buffer  buf;
   
   if( ! _shadow)
   {
      mulle_buffer_init( &buf, MulleObjCObjectGetAllocator( self));
      _mulle_utf32_convert_to_utf8_bytebuffer( &buf, (void *) mulle_buffer_advance,
      [self _fastUTF32StringContents],
      [self _UTF32StringLength]);

      mulle_buffer_add_uint32( &buf, 0);
      _shadow = mulle_buffer_extract_bytes( &buf);
      mulle_buffer_done( &buf);
   }
   return( _shadow);
}


static void   grab_utf32( id self,
                          SEL sel,
                          mulle_utf32_t *storage,
                          NSUInteger len,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   if( range.length + range.location > len)
      MulleObjCThrowInvalidRangeException( range);
   
   memcpy( dst, &storage[ range.location], range.length * sizeof( mulle_utf32_t));
}



- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   grab_utf32( self,
               _cmd,
               [self _fastUTF32StringContents],
               [self length],
               buf,
               range);
}


- (void) dealloc
{
   if( _shadow)
      mulle_allocator_free( MulleObjCObjectGetAllocator( self), _shadow);
   [super dealloc];
}


- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf32_t   *s;
   NSUInteger      length;
   
   length = [self length];
   if( range.location + range.length > length)
      MulleObjCThrowInvalidIndexException( range.location + range.length);
   
   s = [self _fastUTF32StringContents];
   assert( s);
   
   s = &s[ range.location];
   
   return( [[_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:s
                                                               length:range.length
                                                        sharingObject:self] autorelease]);
}

@end


@implementation _MulleObjCGenericUTF32String

+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjCGenericUTF32String   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, length) == length);
   
   obj = NSAllocateObject( self, (length - sizeof( obj->_storage)) * sizeof( mulle_utf32_t), NULL);
   memcpy( obj->_storage, chars, length * sizeof( mulle_utf32_t));
   obj->_length = length;
   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32StringContents
{
   return( _storage);
}

@end


@implementation _MulleObjCAllocatorUTF32String

+ (id) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorUTF32String   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, length) == length);
   
   obj = NSAllocateObject( self, 0, NULL);

   obj->_storage   = chars;
   obj->_length    = length;
   obj->_allocator = allocator;
   
   return( obj);
}

- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32StringContents
{
   return( _storage);
}

- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   [super dealloc];
}

@end



@implementation _MulleObjCSharedUTF32String

+ (id) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                             length:(NSUInteger) length
                      sharingObject:(id) sharingObject
{
   _MulleObjCSharedUTF32String  *data;
   
   NSParameterAssert( mulle_utf32_strnlen( (mulle_utf32_t *) chars, length) == length);

   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage       = chars;
   data->_length        = length;
   data->_sharingObject = [sharingObject retain];
   
   return( data);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf32_t *) _fastUTF32StringContents
{
   return( _storage);
}


- (void) dealloc
{
   [_sharingObject release];
   
   NSDeallocateObject( self);
}

@end


