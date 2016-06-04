/*
 *  MulleFoundation - the mulle-objc class library
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
               [self _fastUTF8Characters],
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


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                 maxLength:(NSUInteger) maxLength
{
   grab_utf8( self,
              _cmd,
              [self _fastUTF8Characters],
              [self length],
              buf,
              maxLength);
}


- (NSUInteger) hash
{
   NSRange       range;
   mulle_utf8_t  *s;
   
   range = MulleObjCHashRange( [self _UTF8StringLength]);
   s     = [self _fastUTF8Characters];
   return( MulleObjCStringHash( s, range.length));
}


- (mulle_utf8_t *) _fastUTF8Characters;
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

   // check both because of overflow range.length == (unsigned) -1 f.e.
   if( range.length + range.location > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);
   
   s = [self _fastUTF8Characters];
   assert( s);
   
   s = &s[ range.location];
   
   // prefer copy for small strings
   if( range.length <= 15)
      return( [NSString _stringWithUTF8Characters:s
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

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8Characters], [obj _UTF8StringLength]) == length);

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

   NSParameterAssert( mulle_utf8_strnlen( [obj _fastUTF8Characters], [obj _UTF8StringLength]) == length);

   return( obj);
}


- (unichar) characterAtIndex:(NSUInteger) index
{
   if( index >= _length + 1)
      MulleObjCThrowInvalidIndexException( index);
   return( _storage[ index]);
}


- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) _storage);
}


- (mulle_utf8_t *) _fastUTF8Characters
{
   return( (mulle_utf8_t *) _storage);
}


- (NSUInteger) _UTF8StringLength
{
   return( _length + 1);
}


- (NSUInteger) length
{
   return( _length + 1);
}


#if 1
- (id) retain
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


- (mulle_utf8_t *) _fastUTF8Characters;
{
   return( (mulle_utf8_t *) self->_storage);
}

@end


@implementation _MulleObjCReferencingASCIIString

+ (id) newWithASCIIStringNoCopy:(char *) s
                         length:(NSUInteger) length
{
   _MulleObjCReferencingASCIIString   *obj;
   
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   if( s[ length])
      MulleObjCThrowInvalidArgumentException( @"string must be zero terminated");
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_storage  = s;
   obj->_length   = length;
   
   return( obj);
}


- (void) dealloc
{
   MulleObjCObjectDeallocateMemory( self, _storage);
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
   return( (mulle_utf8_t *) _storage);
}


- (mulle_utf8_t *) _fastUTF8Characters;
{
   return( (mulle_utf8_t *) _storage);
}

@end


@implementation _MulleObjCAllocatorASCIIString


+ (id) newWithASCIIStringNoCopy:(char *) s
                         length:(NSUInteger) length
                       allocator:(struct mulle_allocator *) allocator
{
   _MulleObjCAllocatorASCIIString   *data;
   
   NSParameterAssert( length);
   NSParameterAssert( mulle_utf8_strnlen( (mulle_utf8_t *) s, length) == length);

   if( s[ length])
      MulleObjCThrowInvalidArgumentException( @"string must be zero terminated");
   
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


- (mulle_utf8_t *) UTF8String
{
   struct mulle_buffer  buffer;
   
   if( ! _shadow)
   {
      mulle_buffer_init( &buffer, MulleObjCObjectGetAllocator( self));
      mulle_buffer_add_bytes( &buffer, _storage, _length);
      mulle_buffer_add_byte( &buffer, 0);
      _shadow = mulle_buffer_extract_bytes( &buffer);
      mulle_buffer_done( &buffer);
   }
   return( _shadow);
}


- (void) dealloc
{
   if( _shadow)
      mulle_allocator_free( MulleObjCObjectGetAllocator( self), _shadow);

   [_sharingObject release];
   
   NSDeallocateObject( self);
}

@end



