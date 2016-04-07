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


//
// I don't remember, why I don't use regular strnlen here
//
static size_t  _mulle_strnlen( char *s, size_t size)
{
   char     *memo;
   char     *sentinel;

   memo     = s;
   sentinel = &s[ size];
   while( s < sentinel && *s)
      ++s;
   return( s - memo);
}


@implementation _MulleObjCASCIIString


static NSUInteger   grab_utf8( id self,
                               SEL sel,
                               utf8char *storage,
                               NSUInteger len,
                               utf8char *dst,
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
                                utf8char *storage,
                                NSUInteger len,
                                utf32char *dst,
                                NSUInteger dst_len,
                                NSRange range)
{
   NSUInteger   end;
   utf8char    *sentinel;
   
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


static inline utf8char  *MulleObjCSmallStringAddress( _MulleObjCASCIIString *self)
{
   return( (utf8char *) self);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= [self length])
      MulleObjCThrowInvalidIndexException( index);
   return( MulleObjCSmallStringAddress( self)[ index]);
}


- (NSUInteger) getUTF32Characters:(utf32char *) buffer
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


- (NSUInteger) getUTF8Characters:(utf8char *) buffer
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


- (utf8char *) _fastUTF8StringContents;
{
   return( MulleObjCSmallStringAddress( self));
}


- (utf8char *) UTF8String
{
   return( MulleObjCSmallStringAddress( self));
}


- (NSString *) substringWithRange:(NSRange) range
{
   utf8char   *s;
   NSUInteger   length;
   
   length = [self length];
   if( range.location + range.length >= length)
      MulleObjCThrowInvalidIndexException( range.location + range.length);
   
   s = [self UTF8String];
   s = &s[ range.location];
   
   return( [NSString stringWithUTF8Characters:s
                                       length:range.length]);
}


static utf8char   *ctype_convert( utf8char *src,
                                  NSUInteger len,
                                  NSRange range,
                                  int (*f_conversion)( int))
{
   utf8char     *buf;
   utf8char     *p;
   utf8char     *sentinel;
   size_t       rest;
   
   buf = MulleObjCAllocateNonZeroedMemory( len + 1);
   
   p        = &buf[ range.location];
   sentinel = &p[ range.length];
   while( p < sentinel)
      *p++ = (utf8char) (*f_conversion)( (char) *src++);

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
   utf8char     *buf;
   NSUInteger   len;
   
   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents], len, NSMakeRange( 0, len), tolower);
   return( [NSString stringWithUTF8String:buf
                                   length:len + 1
                             freeWhenDone:YES]);
}


- (NSString *) uppercaseString
{
   utf8char     *buf;
   NSUInteger   len;
   
   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents], len, NSMakeRange( 0, len), toupper);
   return( [NSString stringWithUTF8String:buf
                                   length:len + 1
                             freeWhenDone:YES]);
}

- (NSString *) capitalizedString
{
   utf8char     *buf;
   NSUInteger   len;
   
   len = [self length];
   buf = ctype_convert( [self _fastUTF8StringContents], len, NSMakeRange( 0, 1), toupper);
   return( [NSString stringWithUTF8String:buf
                                   length:len + 1
                             freeWhenDone:YES]);
}

@end


static void   utf32to8cpy( utf8char *dst, utf32char *src, NSUInteger len)
{
   utf8char   *sentinel;
   
   sentinel = &dst[ len];
   while( dst < sentinel)
   {
      assert( (utf8char) *src == *src);
      *dst++ = (utf8char) *src++;
   }
}


@implementation _MulleObjC03LengthASCIIString

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, 3) == 3);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( [obj autorelease]);
}

+ (id) stringWithUTF32Characters:(utf32char *) chars
                          length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 3) == 3);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( [obj autorelease]);
}

- (NSUInteger) _UTF8StringLength { return( 3); }
- (NSUInteger) length            { return( 3); }

@end


@implementation _MulleObjC07LengthASCIIString

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, 7) == 7);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( [obj autorelease]);
}

+ (id) stringWithUTF32Characters:(utf32char *) chars
                          length:(NSUInteger) length
{
   _MulleObjC07LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 7) == 7);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( [obj autorelease]);
}

- (NSUInteger) _UTF8StringLength  { return( 7); }
- (NSUInteger) length             { return( 7); }

@end


@implementation _MulleObjC11LengthASCIIString

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, 11) == 11);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( [obj autorelease]);
}


+ (id) stringWithUTF32Characters:(utf32char *) chars
                          length:(NSUInteger) length
{
   _MulleObjC11LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 11) == 11);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( [obj autorelease]);
}


- (NSUInteger) _UTF8StringLength { return( 11); }
- (NSUInteger) length            { return( 11); }

@end


@implementation _MulleObjC15LengthASCIIString

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, 15) == 15);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( [obj autorelease]);
}


+ (id) stringWithUTF32Characters:(utf32char *) chars
                          length:(NSUInteger) length
{
   _MulleObjC15LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf32_strnlen( chars, 15) == 15);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   utf32to8cpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( [obj autorelease]);
}


- (NSUInteger) _UTF8StringLength { return( 15); }
- (NSUInteger) length            { return( 15); }

@end


@implementation _MulleObjCTinyASCIIString

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjCTinyASCIIString   *obj;
   NSUInteger                 extra;
   
   NSParameterAssert( length >= 1 && length < 0x100 + 1);
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, length) == length);
   
   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8StringContents], [obj _UTF8StringLength]) == length);

   return( obj);
}


+ (id) stringWithUTF32Characters:(utf32char *) chars
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



- (utf8char *) UTF8String
{
   return( self->_storage);
}


- (utf8char *) _fastUTF8StringContents
{
   return( self->_storage);
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

+ (id) stringWithASCIICharacters:(char *) chars
                           length:(NSUInteger) length
{
   _MulleObjCGenericASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) chars, length) == length);
   
   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}

+ (id) stringWithUTF32Characters:(utf32char *) chars
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


- (utf8char *) UTF8String
{
   return( self->_storage);
}


- (utf8char *) _fastUTF8StringContents;
{
   return( self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

+ (id) stringWithASCIIString:(char *) s
                      length:(NSUInteger) length
{
   _MulleObjCReferencingASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (utf8char *) s, length) == length);
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_storage  = (utf8char *) s;
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


- (utf8char *) UTF8String
{
   return( self->_storage);
}


- (utf8char *) _fastUTF8StringContents;
{
   return( self->_storage);
}

@end
