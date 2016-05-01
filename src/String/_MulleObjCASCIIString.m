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
#include <mulle_utf/mulle_utf.h>


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
   
   if( range.length + range.location > len)
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
               [self _fastUTF8StringContents],
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


- (void) getUTF8Characters:(mulle_utf8_t *) buf
                 maxLength:(NSUInteger) maxLength
{
   grab_utf8( self,
              _cmd,
              [self _fastUTF8StringContents],
              [self length],
              buf,
              maxLength);
}


- (NSUInteger) hash
{
   NSRange   range;
   
   range = MulleObjCHashRange( [self _UTF8StringLength]);
   return( MulleObjCStringHash( [self _fastUTF8StringContents], range.length));
}


- (mulle_utf8_t *) _fastUTF8StringContents;
{
   return( (mulle_utf8_t *) MulleObjCSmallStringAddress( self));
}


- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) MulleObjCSmallStringAddress( self));
}


- (NSString *) substringWithRange:(NSRange) range
{
   mulle_utf8_t   *s;
   NSUInteger   length;
   
   length = [self length];
   if( range.location + range.length > length)
      MulleObjCThrowInvalidIndexException( range.location + range.length);
   
   s = [self _fastUTF8StringContents];
   assert( s);
   
   s = &s[ range.location];
   
   // prefer copy for small strings
   if( range.length <= 15)
      return( [NSString stringWithUTF8Characters:s
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


@implementation _MulleObjC03LengthASCIIString

+ (id) newWithASCIICharacters:(char *) chars
                       length:(NSUInteger) length
{
   _MulleObjC03LengthASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 3) == 3);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 4, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 3);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 7) == 7);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 8, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 7);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 11) == 11);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 12, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 11);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, 15) == 15);
   
   // known to be all zeroed out(!) important!
   obj = NSAllocateObject( self, 16, NULL);
   memcpy( MulleObjCSmallStringAddress( obj), chars, 15);
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);
   
   // we have room for 2 + 0
   extra = length > 2 ? length - 2 : 0;

   obj = NSAllocateObject( self, extra, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length           = (unsigned char) (length - 1); // saved internally this way

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8StringContents], [obj _UTF8StringLength]) == length);

   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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



- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) self->_storage);
}


- (mulle_utf8_t *) _fastUTF8StringContents
{
   return( (mulle_utf8_t *) self->_storage);
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
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) chars, length) == length);
   
   obj = NSAllocateObject( self, length - sizeof( obj->_storage) + 1, NULL);
   memcpy( obj->_storage, chars, length);
   obj->_storage[ length] = 0;
   obj->_length = length;
   return( obj);
}


+ (id) newWithUTF32Characters:(mulle_utf32_t *) chars
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


- (NSUInteger) _UTF8StringLength
{
   return( _length);
}


- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) self->_storage);
}


- (mulle_utf8_t *) _fastUTF8StringContents;
{
   return( (mulle_utf8_t *) self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

+ (id) newWithASCIICharacters:(char *) s
                       length:(NSUInteger) length
{
   _MulleObjCReferencingASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_storage  = s;
   obj->_length   = length;
   
   return( obj);
}


- (void) dealloc
{
   MulleObjCDeallocateMemory( _storage);
   [super dealloc];
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


- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) self->_storage);
}


- (mulle_utf8_t *) _fastUTF8StringContents;
{
   return( (mulle_utf8_t *) self->_storage);
}

@end


@implementation _MulleObjCAllocatorASCIIString

+ (id) newWithASCIICharactersNoCopy:(char *) s
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorASCIIString   *data;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage   = s;
   data->_length    = length;
   data->_allocator = allocator;
   
   return( data);
}

- (void) dealloc
{
   if( _allocator)
      mulle_allocator_free( _allocator, _storage);
   NSDeallocateObject( self);
}

@end


@implementation _MulleObjCSharedASCIIString

+ (id) newWithASCIICharactersNoCopy:(char *) s
                             length:(NSUInteger) length
                      sharingObject:(id) sharingObject
{
   _MulleObjCSharedASCIIString  *data;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   data = NSAllocateObject( self, 0, NULL);
   
   data->_storage       = s;
   data->_length        = length;
   data->_sharingObject = [sharingObject retain];
   
   return( data);
}


- (void) dealloc
{
   [_sharingObject release];
   
   NSDeallocateObject( self);
}

@end



