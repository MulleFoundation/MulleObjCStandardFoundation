//
//  NSString+ClassCluster.m
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

#import "NSString+ClassCluster.h"

// other files in this library
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies
#include <mulle_sprintf/mulle_sprintf.h>


@implementation NSString( ClassCluster)


static NSString  *MulleObjCNewUTF16StringWithUTF8Characters( mulle_utf8_t *s, NSUInteger length, struct mulle_allocator *allocator)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf16len;
   mulle_utf16_t         *utf16;

   assert( length);
   mulle_buffer_init( &buffer, allocator);

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   mulle_utf8_bufferconvert_to_utf16( s,
                                           length,
                                           &buffer,
                                           (void (*)()) mulle_buffer_add_bytes);

   utf16len = mulle_buffer_get_length( &buffer) / 2;
   utf16    = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf16
                                                                 length:utf16len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF16StringWithUTF32Characters( mulle_utf32_t *s, NSUInteger length, struct mulle_allocator   *allocator)
{
   NSUInteger            utf16len;
   mulle_utf16_t         *utf16;
   struct mulle_buffer   buffer;

   assert( length);
   mulle_buffer_init( &buffer, allocator);

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf16_t));
   mulle_utf32_bufferconvert_to_utf16( s,
                                       length,
                                       &buffer,
                                       (void (*)()) mulle_buffer_add_bytes);

   utf16len = mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t);
   utf16    = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf16
                                                                 length:utf16len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF32StringWithUTF8Characters( mulle_utf8_t *s, NSUInteger length, struct mulle_allocator   *allocator)
{
   struct mulle_buffer   buffer;
   NSUInteger            utf32len;
   mulle_utf32_t         *utf32;

   assert( length);
   assert( allocator);

   mulle_buffer_init( &buffer, allocator);

   // make intital alloc large enough for optimal case
   mulle_buffer_guarantee( &buffer, length * sizeof( mulle_utf32_t));
   mulle_utf8_bufferconvert_to_utf32( s,
                                           length,
                                           &buffer,
                                           (void (*)()) mulle_buffer_add_bytes);

   utf32len = mulle_buffer_get_length( &buffer) / sizeof( unichar);
   utf32    = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf32
                                                                 length:utf32len
                                                              allocator:allocator]);
}


static NSString  *MulleObjCNewUTF32StringWithUTF32Characters( mulle_utf32_t *s, NSUInteger length)
{
   assert( length);
   return( [_MulleObjCGenericUTF32String newWithUTF32Characters:s
                                                         length:length]);
}


static void   _NSThrowInvalidUTF8Exception( mulle_utf8_t *s,
                                            struct mulle_utf_information *info)
{
   struct mulle_buffer   buffer;
   auto char             space[ 256];
   mulle_utf8_t          *p;
   size_t                len;

   if( s > (mulle_utf8_t *) info->invalid)
      mulle_objc_throw_invalid_argument_exception( "UTF8 internal corruption, no data can be shown");

   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), NULL);

   p   = info->invalid;
   len = 16;
   p  -= 15;
   if( p < s)
   {
      p  += 15;
      len = p - s;
      p   = s;
   }

   mulle_buffer_add_string( &buffer, "Invalid UTF8 (last value): ");
   mulle_buffer_hexdump( &buffer, (uint8_t *) p, len, (size_t) (s - p), -1);

   mulle_objc_throw_invalid_argument_exception( space);
}


static void   _NSThrowInvalidUTF32Exception( mulle_utf32_t *s,
                                             struct mulle_utf_information *info)
{
   struct mulle_buffer   buffer;
   auto char             space[ 256];
   mulle_utf32_t         *p;
   size_t                len;


   if( s > (mulle_utf32_t *) info->invalid)
      mulle_objc_throw_invalid_argument_exception( "UTF32 internal corruption, no data can be shown");

   mulle_buffer_init_with_static_bytes( &buffer, space, sizeof( space), NULL);

   p   = info->invalid;
   len = 4;
   p  -= 3;
   if( p < s)
   {
      p  += 3;
      len = p - s;
      p   = s;
   }

   mulle_buffer_add_string( &buffer, "Invalid UTF32 (last values): ");
   mulle_buffer_hexdump( &buffer, (uint8_t *) p, len, (size_t) (s - p), -1);

   mulle_objc_throw_invalid_argument_exception( space);
}


static NSString  *newStringWithUTF8Characters( mulle_utf8_t *buf,
                                               NSUInteger len,
                                               struct mulle_allocator *allocator)
{
   struct mulle_utf_information   info;

   if( mulle_utf8_information( buf, len, &info))
      _NSThrowInvalidUTF8Exception( buf, &info);

#ifndef MULLE_OBJC_NO_TAGGED_POINTERS
   if( info.is_ascii && info.utf8len <= mulle_char7_get_maxlength())
      return( MulleObjCTaggedPointerChar7StringWithASCIICharacters( (char *) info.start, info.utf8len));
   if( info.is_char5 && info.utf8len <= mulle_char5_get_maxlength())
      return( MulleObjCTaggedPointerChar5StringWithASCIICharacters( (char *) info.start, info.utf8len));
#endif

   if( info.is_ascii)
      return( MulleObjCNewASCIIStringWithASCIICharacters( (char *) info.start, info.utf8len));

   if( info.is_utf15)
      return( MulleObjCNewUTF16StringWithUTF8Characters( info.start, info.utf8len, allocator));

   return( MulleObjCNewUTF32StringWithUTF8Characters( info.start, info.utf8len, allocator));
}


static NSString  *newStringWithUTF32Characters( mulle_utf32_t *buf,
                                                NSUInteger len,
                                                struct mulle_allocator *allocator)
{
   struct mulle_utf_information  info;

   if( mulle_utf32_information( buf, len, &info))
      _NSThrowInvalidUTF32Exception( buf, &info);

   if( info.is_ascii)
      return( MulleObjCNewASCIIStringWithUTF32Characters( info.start, info.utf32len));

   if( info.is_utf15)
      return( MulleObjCNewUTF16StringWithUTF32Characters( info.start, info.utf32len, allocator));

   return( MulleObjCNewUTF32StringWithUTF32Characters( info.start, info.utf32len));
}


#pragma mark -
#pragma mark class cluster init


- (instancetype) initWithUTF8String:(char *) s
{
   struct mulle_allocator  *allocator;

   if( ! s)
      MulleObjCThrowInvalidArgumentException( @"argument must not be null");

   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF8Characters( (mulle_utf8_t *) s,
                                             mulle_utf8_strlen( (mulle_utf8_t *) s),
                                             allocator));
}


- (instancetype) _initWithUTF8Characters:(mulle_utf8_t *) s
                                  length:(NSUInteger) len
{
   struct mulle_allocator  *allocator;

   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF8Characters( s, len, allocator));
}



- (instancetype) initWithCharacters:(unichar *) s
                   length:(NSUInteger) len
{
   struct mulle_allocator  *allocator;

   allocator = MulleObjCObjectGetAllocator( self);
   [self release];
   return( (id) newStringWithUTF32Characters( s, len, allocator));
}


- (instancetype) _initWithCharactersNoCopy:(unichar *) s
                                    length:(NSUInteger) length
                                 allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf_information   info;

   if( mulle_utf32_information( s, length, &info))
      _NSThrowInvalidUTF32Exception( s, &info);

   if( info.has_bom)
   {
      self = [self initWithCharacters:s
                               length:length];
      mulle_allocator_free( allocator, s);
      return( self);
   }

   [self release];
   return( [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:info.start
                                                                 length:info.utf32len
                                                              allocator:allocator]);
}


- (instancetype) initWithCharactersNoCopy:(unichar *) chars
                                   length:(NSUInteger) length
                             freeWhenDone:(BOOL) flag
{
   struct mulle_allocator   *allocator;

   allocator = flag ? &mulle_stdlib_allocator : NULL;
   return( [self _initWithCharactersNoCopy:chars
                                    length:length
                                 allocator:allocator]);
}


- (instancetype) _initWithNonASCIIUTF8Characters:(mulle_utf8_t *) s
                                          length:(NSUInteger) length
                                        userInfo:(void *) userInfo
{
   struct mulle_utf_information   *info;
   struct mulle_utf_information   _info;
   struct mulle_buffer            buffer;
   void                           *utf;
   struct mulle_allocator         *allocator;

   info = userInfo;
   if( ! info)
   {
      info = &_info;
      if( mulle_utf8_information( s, length, info))
        _NSThrowInvalidUTF8Exception( s, info);
   }


   if( ! info->utf8len)
   {
      [self release];
      return( @"");
   }


   // need to copy it, because it's not ASCII

   allocator = MulleObjCObjectGetAllocator( self);
   mulle_buffer_init( &buffer, allocator);

   [self release];

   // convert it to UTF16
   // make it a regular string
   if( info->is_utf15)
   {
      mulle_utf8_bufferconvert_to_utf16( info->start,
                                              info->utf8len,
                                              &buffer,
                                              (void (*)()) mulle_buffer_add_bytes);
      assert( info->utf16len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf16_t));
      utf = mulle_buffer_extract_all( &buffer);

      self = [_MulleObjCAllocatorUTF16String newWithUTF16CharactersNoCopy:utf
                                                                   length:info->utf16len
                                                                allocator:allocator];
   }
   else
   {
      mulle_utf8_bufferconvert_to_utf32( info->start,
                                              info->utf8len,
                                              &buffer,
                                              (void (*)()) mulle_buffer_add_bytes);
      assert( info->utf32len == mulle_buffer_get_length( &buffer) / sizeof( mulle_utf32_t));
      utf = mulle_buffer_extract_all( &buffer);

      self = [_MulleObjCAllocatorUTF32String newWithUTF32CharactersNoCopy:utf
                                                                   length:info->utf32len
                                                                allocator:allocator];
   }

   mulle_buffer_done( &buffer);
   return( self);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                     allocator:(struct mulle_allocator *) allocator
{
   struct mulle_utf_information   info;
   id                             obj;

   assert( length <= NSIntegerMax);

   if( mulle_utf8_information( s, length, &info))
      _NSThrowInvalidUTF8Exception( s, &info);

   obj = [self _initWithNonASCIIUTF8Characters:info.start
                                        length:info.utf8len
                                      userInfo:&info];

   // free it, because we don't use it
   if( allocator)
      mulle_allocator_free( allocator, s);

   return( obj);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                  freeWhenDone:(BOOL) flag;
{
   struct mulle_allocator   *allocator;

   allocator = flag ? &mulle_stdlib_allocator : NULL;
   return( [self _initWithUTF8CharactersNoCopy:s
                                        length:length
                                     allocator:allocator]);
}


- (instancetype) _initWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                        length:(NSUInteger) length
                                 sharingObject:(id) object
{
   struct mulle_utf_information   info;

   if( mulle_utf8_information( s, length, &info))
      _NSThrowInvalidUTF8Exception( s, &info);

   return( [self _initWithNonASCIIUTF8Characters:info.start
                                          length:info.utf8len
                                        userInfo:&info]);

}


- (instancetype) _initWithCharactersNoCopy:(unichar *) s
                                    length:(NSUInteger) length
                             sharingObject:(id) object
{
   [self release];
   return( [_MulleObjCSharedUTF32String newWithUTF32CharactersNoCopy:s
                                                              length:length
                                                       sharingObject:object]);
}

@end
