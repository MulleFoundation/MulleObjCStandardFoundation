//
//  _MulleObjCUTF16String.m
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

#import "NSString.h"

#include <mulle-utf/mulle-utf.h>


#import "_MulleObjCUTF16String.h"

// other files in this library
#import "NSString+NSData.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#import <mulle-buffer/mulle-buffer.h>


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCUTF16String

- (mulle_utf16_t *) _fastUTF16Characters
{
   return( NULL);
}


- (mulle_utf8_t *) mulleFastUTF8Characters
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


- (NSUInteger) mulleUTF8StringLength
{
   return( mulle_utf16_utf8length( [self _fastUTF16Characters], _length));
}


- (mulle_utf8_t *) UTF8String
{
   struct mulle_buffer   buf;

   if( ! _shadow)
   {
      mulle_buffer_init( &buf, MulleObjCObjectGetAllocator( self));
      mulle_utf16_bufferconvert_to_utf8( [self _fastUTF16Characters],
                                         [self _UTF16StringLength],
                                         &buf,
                                         (void (*)()) mulle_buffer_add_bytes);

      mulle_buffer_add_byte( &buf, 0);
      _shadow = mulle_buffer_extract_all( &buf);
      mulle_buffer_done( &buf);
   }
   return( _shadow);
}


static void   grab_utf32( id self,
                          SEL sel,
                          mulle_utf16_t *storage,
                          NSUInteger length,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   mulle_utf16_t    *sentinel;

   // check both because of overflow range.length == (unsigned) -1 f.e.
   MulleObjCValidateRangeWithLength( range, length);

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
   MulleObjCValidateRangeWithLength( range, length);

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

- (NSUInteger) lengthOfBytesUsingEncoding:(NSStringEncoding) encoding
{
   switch( encoding)
   {
   case NSUTF16StringEncoding : return( [self length] * sizeof( mulle_utf16_t));
   case NSUTF32StringEncoding : return( [self length] * sizeof( mulle_utf32_t));
   }
   return( [super lengthOfBytesUsingEncoding:encoding]);
}

@end


@implementation _MulleObjCGenericUTF16String

+ (instancetype) newWithUTF16Characters:(mulle_utf16_t *) chars
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

+ (instancetype) newWithUTF16CharactersNoCopy:(void *) chars
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorUTF16String   *obj;

   NSParameterAssert( mulle_utf16_strnlen( chars, length) == length);

   obj             = NSAllocateObject( self, 0, NULL);
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

+ (instancetype) newWithUTF16CharactersNoCopy:(mulle_utf16_t *) chars
                                       length:(NSUInteger) length
                                sharingObject:(id) sharingObject
{
   _MulleObjCSharedUTF16String  *data;

   NSParameterAssert( mulle_utf16_strnlen( (mulle_utf16_t *) chars, length) == length);

   data                 = NSAllocateObject( self, 0, NULL);
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

   [super dealloc];
}

@end
