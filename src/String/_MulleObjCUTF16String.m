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

- (utf8char *) _fastUTF8StringContents;
{
   return( NULL);
}

@end


@implementation _MulleObjCGenericUTF16String

+ (id) stringWithUTF16Characters:(utf16char *) chars
                          length:(NSUInteger) length
{
   _MulleObjCGenericUTF16String   *obj;
   
   NSParameterAssert( mulle_utf16_strnlen( chars, length) == length);
   
   obj = NSAllocateObject( self, (length - sizeof( obj->_storage) + 1) * sizeof( utf16char), NULL);
   memcpy( obj->_storage, chars, length * sizeof( utf16char));
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger)index
{
   if( index >= _length)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) _UTF8StringLength
{
   return( mulle_utf16_length_as_utf8( _storage, _length));
}


- (utf8char *) UTF8String
{
   struct mulle_buffer  buf;
   
   if( ! _shadow)
   {
      mulle_buffer_init( &buf, MulleObjCAllocator());
      _mulle_utf16_convert_to_utf8_bytebuffer( &buf, (void *) mulle_buffer_guarantee, _storage, _length + 1);
      _shadow = mulle_buffer_extract( &buf);
      mulle_buffer_done( &buf);
   }
   return( _shadow);
}


- (void) dealloc
{
   if( _shadow)
      mulle_allocator_free( MulleObjCAllocator(), _shadow);
   [super dealloc];
}

@end
