//
//  _MulleObjCASCIIString.m
//  MulleObjCStandardFoundation
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
#import "NSString.h"

#import "_MulleObjCASCIIString.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <mulle-buffer/mulle-buffer.h>
#include <mulle-utf/mulle-utf.h>

#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCASCIIString

static inline char  *MulleObjCSmallStringAddress( _MulleObjCASCIIString *self)
{
   return( (char *) self);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= [self length])
      MulleObjCThrowInvalidIndexException( index);
   return( MulleObjCSmallStringAddress( self)[ index]);
}


static void   grab_utf32( id self,
                          SEL sel,
                          mulle_utf8_t *storage,
                          NSUInteger len,
                          mulle_utf32_t *dst,
                          NSRange range)
{
   mulle_utf8_t    *sentinel;

   // check both because of overflow range.length == (unsigned) -1 f.e.
   MulleObjCValidateRangeWithLength( range, len);

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
               [self mulleFastUTF8Characters],
               [self length],
               buf,
               range);
}


static void   grab_utf8( id self,
                         SEL sel,
                         mulle_utf8_t *storage,
                         NSUInteger len,
                         mulle_utf8_t *dst,
                         NSUInteger dst_len)
{
   if( dst_len < len)
      MulleObjCThrowInvalidArgumentException( @"destination buffer too small");

   memcpy( dst, storage, len);
}


- (void) mulleGetUTF8Characters:(mulle_utf8_t *) buf
                  maxLength:(NSUInteger) maxLength
{
   grab_utf8( self,
              _cmd,
              [self mulleFastUTF8Characters],
              [self length],
              buf,
              maxLength);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( MulleObjCStringHash( [self mulleFastUTF8Characters],
                                [self mulleUTF8StringLength]));
}


- (mulle_utf8_t *) mulleFastUTF8Characters
{
   return( (mulle_utf8_t *) MulleObjCSmallStringAddress( self));
}


- (char *) UTF8String
{
   return( MulleObjCSmallStringAddress( self));
}


- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf8_t   *s;
   NSUInteger     length;

   length = [self length];

   // check both because of overflow range.length == (unsigned) -1 f.e.
   MulleObjCValidateRangeWithLength( range, length);

   s = [self mulleFastUTF8Characters];
   assert( s);

   s = &s[ range.location];

   // prefer copy for small strings
   if( range.length <= 15)
      return( [NSString mulleStringWithUTF8Characters:s
                                           length:range.length]);

   return( [[_MulleObjCSharedASCIIString newWithASCIICharactersNoCopy:(char *) s
                                                               length:range.length
                                                        sharingObject:self] autorelease]);
}


@end


static void   utf32to8cpy( char *dst, mulle_utf32_t *src, NSUInteger len)
{
   char   *sentinel;

   sentinel = &dst[ len];
   while( dst < sentinel)
   {
      assert( (mulle_utf8_t) *src == *src);
      *dst++ = (mulle_utf8_t) *src++;
   }
}


#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES

@implementation _MulleObjC03LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 3) == 3);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf32_strnlen( chars, 3) == 3);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 3); }
- (NSUInteger) length            { return( 3); }

@end


@implementation _MulleObjC07LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 7) == 7);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf32_strnlen( chars, 7) == 7);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}

- (NSUInteger) mulleUTF8StringLength  { return( 7); }
- (NSUInteger) length             { return( 7); }

@end


@implementation _MulleObjC11LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 11) == 11);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf32_strnlen( chars, 11) == 11);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 11); }
- (NSUInteger) length            { return( 11); }

@end


@implementation _MulleObjC15LengthASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 15) == 15);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;

   NSParameterAssert( mulle_utf32_strnlen( chars, 15) == 15);

   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


- (NSUInteger) mulleUTF8StringLength { return( 15); }
- (NSUInteger) length            { return( 15); }

@end

#endif


@implementation _MulleObjCTinyASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;

   NSParameterAssert( length >= 1 && length < 0x100 + 1);
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);

   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   NSParameterAssert( mulle_utf8_strnlen( [obj mulleFastUTF8Characters], [obj mulleUTF8StringLength]) == length);

   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;

   NSParameterAssert( length >= 1 && length < 0x100 + 1);
   NSParameterAssert( mulle_utf32_strnlen( chars, length) == length);

   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   utf32to8cpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   NSParameterAssert( mulle_utf8_strnlen( [obj mulleFastUTF8Characters], [obj mulleUTF8StringLength]) == length);

   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= _length + 1)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (char *) UTF8String
{
   return( _storage);
}

- (mulle_utf8_t *) mulleFastASCIICharacters
{
   return( (mulle_utf8_t *) _storage);
}


- (mulle_utf8_t *) mulleFastUTF8Characters
{
   return( (mulle_utf8_t *) _storage);
}


- (NSUInteger) mulleUTF8StringLength
{
   return( _length + 1);
}


- (NSUInteger) length
{
   return( _length + 1);
}


#if 1
- (instancetype) retain
{
   return( [super retain]);
}
#endif


- (void) release
{
   [super release];
}

@end


@implementation _MulleObjCGenericASCIIString

+ (instancetype) newWithASCIICharacters:(char *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);

   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}


+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;

   NSParameterAssert( mulle_utf32_strnlen( chars, length) == length);

   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   utf32to8cpy( obj->_storage, chars, length);
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


- (NSUInteger) mulleUTF8StringLength
{
   return( _length);
}


- (char *) UTF8String
{
   return( self->_storage);
}


- (mulle_utf8_t *) mulleFastUTF8Characters;
{
   return( (mulle_utf8_t *) self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

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


- (NSUInteger) mulleUTF8StringLength
{
   return( _length);
}


- (mulle_utf8_t *) mulleFastUTF8Characters
{
   return( (mulle_utf8_t *) _storage);
}


- (char *) UTF8String
{
   struct mulle_buffer  buffer;

   if( ! _shadow)
   {
      mulle_buffer_init( &buffer, MulleObjCObjectGetAllocator( self));
      mulle_buffer_add_bytes( &buffer, _storage, _length);
      mulle_buffer_add_byte( &buffer, 0);
      _shadow = mulle_buffer_extract_all( &buffer);
      mulle_buffer_done( &buffer);
   }
   return( (char *) _shadow);
}


- (void) dealloc
{
   if( _shadow)
      mulle_allocator_free( MulleObjCObjectGetAllocator( self), _shadow);

   NSDeallocateObject( self);
}

@end



@implementation _MulleObjCSharedASCIIString

+ (instancetype) newWithASCIICharactersNoCopy:(char *) s
                                       length:(NSUInteger) length
                                sharingObject:(id) sharingObject
{
   _MulleObjCSharedASCIIString  *data;

   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   data                 = NSAllocateObject( self, 0, NULL);
   data->_storage       = s;
   data->_length        = length;
   data->_sharingObject = [sharingObject retain];

   return( data);
}


- (void) dealloc
{
   [_sharingObject release];
   [super dealloc];
}

@end


@implementation _MulleObjCAllocatorASCIIString

static _MulleObjCAllocatorASCIIString   *
   _MulleObjCAllocatorASCIIStringNew( Class self,
                                      char *s,
                                      NSUInteger length,
                                      struct mulle_allocator *allocator)
{
   _MulleObjCAllocatorASCIIString   *string;

   NSCParameterAssert( length);
   NSCParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   string             = NSAllocateObject( self, 0, NULL);
   string->_storage   = s;
   string->_length    = length;
   string->_allocator = allocator;

   return( string);
}


+ (instancetype) newWithASCIICharactersNoCopy:(char *) s
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator
{
   return( _MulleObjCAllocatorASCIIStringNew( self, s, length, allocator));
}


- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   [super dealloc];
}

@end


@implementation _MulleObjCAllocatorZeroTerminatedASCIIString


+ (instancetype) newWithZeroTerminatedASCIICharactersNoCopy:(char *) s
                                                     length:(NSUInteger) length
                                                  allocator:(struct mulle_allocator *) allocator
{
   if( s[ length])
      MulleObjCThrowInvalidArgumentException( @"is not zero terminated");

   return( (_MulleObjCAllocatorZeroTerminatedASCIIString *)
               _MulleObjCAllocatorASCIIStringNew( self, s, length, allocator));
}

- (char *) UTF8String
{
   return( self->_storage);
}

@end

