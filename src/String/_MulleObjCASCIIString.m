/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  MulleObjCASCIIString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "_MulleObjCASCIIString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c and dependencies
#include <ctype.h>


@implementation _MulleObjCASCIIString


static NSUInteger   grab_utf8( id self,
                               SEL sel,
                               mulle_utf8char_t *storage,
                               NSUInteger len,
                               mulle_utf8char_t *dst,
                               NSUInteger dst_len,
                               NSRange range)
{
   NSUInteger   end;
   
   // ex.  string    = "VfL Bochum" (10)
   //      range     = {2,8}
   //      maxLength = 4
   
   end = MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, len);
   if( end >= dst_len)
      end = range.location + dst_len - 1;
   
   len = end - range.location;
   memcpy( dst, &storage[ range.location], len);
   return( len);
}


static NSUInteger   grab_utf32( id self,
                                SEL sel,
                                mulle_utf8char_t *storage,
                                NSUInteger len,
                                mulle_utf32char_t *dst,
                                NSUInteger dst_len,
                                NSRange range)
{
   NSUInteger   end;
   mulle_utf8char_t    *sentinel;
   
   // ex.  string    = "VfL Bochum" (10)
   //      range     = {2,8}
   //      maxLength = 4
   
   end = MulleObjCGetMaxRangeLengthAndRaiseOnInvalidRange( range, len);
   if( end >= dst_len)
      end = range.location + dst_len - 1;
   
   len      = end - range.location;
   storage  = &storage[ range.location];
   sentinel = &storage[ len];
   
   while( storage < sentinel)
      *storage++ = *sentinel++;
   return( len);
}


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


- (NSUInteger) getUTF32Characters:(mulle_utf32char_t *) buffer
                        maxLength:(NSUInteger) maxLength
                            range:(NSRange) range
{
   return( grab_utf32( self,
                       _cmd,
                       [self _fastUTF8StringContents],
                       [self length],
                       buffer,
                       maxLength,
                       range));
}


- (NSUInteger) getUTF8Characters:(mulle_utf8char_t *) buffer
                       maxLength:(NSUInteger) maxLength
                           range:(NSRange) range
{
   return( grab_utf8( self,
                      _cmd,
                      [self _fastUTF8StringContents],
                      [self length],
                      buffer,
                      maxLength,
                      range));
}


- (mulle_utf8char_t *) _fastUTF8StringContents;
{
   return( (mulle_utf8char_t *) MulleObjCSmallStringAddress( self));
}


- (mulle_utf8char_t *) UTF8String
{
   return( (mulle_utf8char_t *) MulleObjCSmallStringAddress( self));
}


- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf8char_t   *s;
   NSUInteger   length;
   
   length = [self length];
   if( range.location + range.length >= length)
      MulleObjCThrowInvalidIndexException( range.location + range.length);
   
   s = [self UTF8String];
   s = &s[ range.location];
   
   return( [NSString stringWithUTF8Characters:s
                                       length:range.length]);
}


static mulle_utf8char_t   *ctype_convert( mulle_utf8char_t *src,
                                          NSUInteger len,
                                          NSRange range,
                                          int (*f_conversion)( int),
                                          struct mulle_allocator *allocator)
{
   mulle_utf8char_t     *buf;
   mulle_utf8char_t     *p;
   mulle_utf8char_t     *sentinel;
   size_t       rest;
   
   buf = mulle_allocator_malloc( allocator, len + 1);
   
   p        = &buf[ range.location];
   sentinel = &p[ range.length];
   while( p < sentinel)
      *p++ = (mulle_utf8char_t) (*f_conversion)( (char) *src++);

   rest = &buf[ len] - p;
   if( rest)
   {
      memcpy( p, src, rest);
      p = &p[ rest];
   }

   *p = 0;
   return( buf);
}


- (NSString *) lowercaseString
{
   NSUInteger               len;
   mulle_utf8char_t         *buf;
   struct mulle_allocator   *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);

   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents],
                        len,
                        NSMakeRange( 0, len),
                        tolower,
                        allocator);
   return( [NSString stringWithUTF8CharactersNoCopy:buf
                                             length:len + 1
                                          allocator:allocator]);
}


- (NSString *) uppercaseString
{
   NSUInteger               len;
   mulle_utf8char_t         *buf;
   struct mulle_allocator   *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);
   
   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents],
                         len,
                         NSMakeRange( 0, len),
                         toupper,
                         allocator);
   return( [NSString stringWithUTF8CharactersNoCopy:buf
                                             length:len
                                          allocator:allocator]);
}


- (NSString *) capitalizedString
{
   NSUInteger               len;
   mulle_utf8char_t         *buf;
   struct mulle_allocator   *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);

   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents],
                        len,
                        NSMakeRange( 0, 1),
                        toupper,
                        allocator);

   return( [NSString stringWithUTF8CharactersNoCopy:buf
                                             length:len
                                          allocator:allocator]);
}

@end


static void   utf32to8cpy( char *dst, mulle_utf32char_t *src, NSUInteger len)
{
   char   *sentinel;
   
   sentinel = &dst[ len];
   while( dst < sentinel)
   {
      assert( (mulle_utf8char_t) *src == *src);
      *dst++ = (mulle_utf8char_t) *src++;
   }
}


@implementation _MulleObjC03LengthASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, 3) == 3);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 3) == 3);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}

- (NSUInteger) _UTF8StringLength { return( 3); }
- (NSUInteger) length            { return( 3); }

@end


@implementation _MulleObjC07LengthASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, 7) == 7);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 7) == 7);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}

- (NSUInteger) _UTF8StringLength  { return( 7); }
- (NSUInteger) length             { return( 7); }

@end


@implementation _MulleObjC11LengthASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, 11) == 11);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 11) == 11);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


- (NSUInteger) _UTF8StringLength { return( 11); }
- (NSUInteger) length            { return( 11); }

@end


@implementation _MulleObjC15LengthASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, 15) == 15);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
                       length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 15) == 15);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


- (NSUInteger) _UTF8StringLength { return( 15); }
- (NSUInteger) length            { return( 15); }

@end


@implementation _MulleObjCTinyASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;
   
   NSParameterAssert( length >= 1 && length < 0x100 + 1);
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, length) == length);
   
   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8StringContents], [obj _UTF8StringLength]) == length);

   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
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

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8StringContents], [obj _UTF8StringLength]) == length);

   return( obj);
}



- (mulle_utf8char_t *) UTF8String
{
   return( (mulle_utf8char_t *) self->_storage);
}


- (mulle_utf8char_t *) _fastUTF8StringContents
{
   return( (mulle_utf8char_t *) self->_storage);
}


- (NSUInteger) _UTF8StringLength
{
   return( _length + 1);
}


- (NSUInteger) length
{
   return( _length + 1);
}

@end


@implementation _MulleObjCGenericASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) chars, length) == length);
   
   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
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


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   [self getUTF32Characters:buf
                  maxLength:LONG_MAX
                      range:range];
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
   return( _length);
}


- (mulle_utf8char_t *) UTF8String
{
   return( (mulle_utf8char_t *) self->_storage);
}


- (mulle_utf8char_t *) _fastUTF8StringContents;
{
   return( (mulle_utf8char_t *) self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

+ (id) newWithASCIICharacters:(char *) s
                       length:(NSUInteger) length
{
   _MulleObjCReferencingASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8char_t *) s, length) == length);
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_storage  = (mulle_utf8char_t *) s;
   obj->_length   = length;
   return( obj);
}


- (void) dealloc
{
   MulleObjCDeallocateMemory( _storage);
   [super dealloc];
}


- (void) getCharacters:(unichar *) buf
                 range:(NSRange) range
{
   [self getUTF32Characters:buf
                  maxLength:LONG_MAX
                      range:range];
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
   return( _length);
}


- (mulle_utf8char_t *) UTF8String
{
   return( self->_storage);
}


- (mulle_utf8char_t *) _fastUTF8StringContents;
{
   return( self->_storage);
}

@end


@implementation _MulleObjCAllocatorASCIIString

+ (id) newWithASCIICharactersNoCopy:(char *) chars
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorASCIIString   *data;
   
   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = chars;
   data->_length    = length;
   data->_allocator = allocator;
   
   return( data);
}


- (mulle_utf8char_t *) UTF8String
{
   return( (mulle_utf8char_t *) self->_storage);
}


- (mulle_utf8char_t *) _fastUTF8StringContents
{
   return( (mulle_utf8char_t *) _storage);
}


- (NSUInteger) length
{
   return( _length);
}


- (NSUInteger) _UTF8StringLength
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


