//
//  MulleObjCUTF16String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCUTF16String.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <mulle_container/mulle_container.h>


@implementation _MulleObjCUTF16String

- (mulle_utf16_t *) _fastUTF16Characters;
{
   return( NULL);
}


- (mulle_utf8_t *) _fastUTF8Characters;
{
   return( NULL);
}


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) _UTF16StringLength
{
   return( _length);
}


- (NSUInteger) _UTF8StringLength
{
   return( mulle_utf16_length_as_utf8( [self _fastUTF16Characters], _length));
}


- (mulle_utf8_t *) UTF8String
{
   struct mulle_buffer  buf;
   
   if( ! _shadow)
   {
      mulle_buffer_init( &buf, MulleObjCObjectGetAllocator( self));
      mulle_utf16_convert_to_utf8_bytebuffer( [self _fastUTF16Characters],
                                              [self _UTF16StringLength],
                                              &buf,
                                              (void (*)()) mulle_buffer_add_bytes);

      mulle_buffer_add_byte( &buf, 0);
      _shadow = mulle_buffer_extract_bytes( &buf);
      mulle_buffer_done( &buf);
   }
   return( _shadow);
}


static void   grab_utf32( id self,
                          SEL sel,
                          mulle_utf16_t *storage,
                          NSUInteger len,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   mulle_utf16_t    *sentinel;
   
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > len || range.length > len)
      MulleObjCThrowInvalidRangeException( range);
   
   storage  = &storage[ range.location];
   sentinel = &storage[ range.length];
   
   while( storage < sentinel)
      *dst++ = *storage++;
}



- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   grab_utf32( self,
               _cmd,
               [self _fastUTF16Characters],
               [self length],
               buf,
               range);
}


- (void) dealloc
{
   if( _shadow)
      MulleObjCObjectDeallocateMemory( self, _shadow);
   [super dealloc];
}

- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf16_t   *s;
   NSUInteger      length;
   
   length = [self length];
   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);

   if( range.length == length)
      return( self);
   
   if( ! range.length)
      return( @"");
   
   s = [self _fastUTF16Characters];
   assert( s);
   
   return( [[_MulleObjCSharedUTF16String newWithUTF16CharactersNoCopy:&s[ range.location]
                                                               length:range.length
                                                        sharingObject:self] autorelease]);
}

@end


@implementation _MulleObjCGenericUTF16String

+ (id) newWithUTF16Characters:(mulle_utf16_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjCGenericUTF16String   *obj;
   
   NSParameterAssert( mulle_utf16_strnlen( chars, length) == length);
   
   obj = NSAllocateObject( self, (length * sizeof( mulle_utf16_t)) - sizeof( obj->_storage), NULL);
   memcpy( obj->_storage, chars, length * sizeof( mulle_utf16_t));
   obj->_length = length;
   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf16_t *) _fastUTF16Characters
{
   return( _storage);
}

@end


@implementation _MulleObjCAllocatorUTF16String

+ (id) newWithUTF16CharactersNoCopy:(void *) chars
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorUTF16String   *obj;
   
   NSParameterAssert( mulle_utf16_strnlen( chars, length) == length);
   
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


- (mulle_utf16_t *) _fastUTF16Characters
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


@implementation _MulleObjCSharedUTF16String

+ (id) newWithUTF16CharactersNoCopy:(mulle_utf16_t *) chars
                             length:(NSUInteger) length
                      sharingObject:(id) sharingObject
{
   _MulleObjCSharedUTF16String  *data;
   
   NSParameterAssert( mulle_utf16_strnlen( (mulle_utf16_t *) chars, length) == length);

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


- (mulle_utf16_t *) _fastUTF16Characters
{
   return( _storage);
}


- (void) dealloc
{
   [_sharingObject release];
   
   NSDeallocateObject( self);
}

@end

