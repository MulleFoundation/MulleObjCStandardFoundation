//
//  NSString.m
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

// other files in this library
#import "NSString+ClassCluster.h"
#import "NSString+Search.h"
#import "_MulleObjCTaggedPointerChar5String.h"
#import "_MulleObjCTaggedPointerChar7String.h"
#import "_MulleObjCASCIIString.h"
#import "_MulleObjCUTF16String.h"
#import "_MulleObjCUTF32String.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationBase.h"
#import "NSException.h"
#import "NSAssertionHandler.h"

// std-c and dependencies
#import <mulle-utf/mulle-utf.h>
#import <ctype.h>
#import <MulleObjC/private/mulle-objc-universefoundationinfo-private.h>

#if MULLE_UTF_VERSION < ((1 << 20) | (0 << 8) | 0)
# error "mulle_utf is too old"
#endif


@implementation NSObject( _NSString)

- (BOOL) __isNSString
{
   return( NO);
}

@end


@interface NSObject( Initialize)

+ (void) initialize;

@end


@implementation NSString

#pragma mark - Patch string class into runtime

static char   *stringToUTF8( NSString *s)
{
   return( [s UTF8String]);
}


static NSString   *UTF8ToString( char *s)
{
   return( [NSString stringWithUTF8String:s]);
}


+ (void) load
{
   struct _mulle_objc_universefoundationinfo   *config;

   config = _mulle_objc_universe_get_universefoundationinfo( MulleObjCObjectGetUniverse( self));

   config->string.charsfromobject = (char *(*)()) stringToUTF8;
   config->string.objectfromchars = (void *(*)()) UTF8ToString;
}


- (BOOL) __isNSString
{
   return( YES);
}


# pragma mark - Class cluster support

// here and not in +Classcluster for +initialize

enum _NSStringClassClusterStringSize
{
   _NSStringClassClusterStringSize0         = 0,
   _NSStringClassClusterStringSizeOther     = 1,
   _NSStringClassClusterStringSize256OrLess = 2,
#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
   _NSStringClassClusterStringSize3         = 3,
   _NSStringClassClusterStringSize7         = 4,
   _NSStringClassClusterStringSize11        = 5,
   _NSStringClassClusterStringSize15        = 6,
#endif
   _NSStringClassClusterStringSizeMax
};


//
// it is useful for coverage, to make all possible subclasses known here
// Otherwise someone might only test with 255 bytes strings and it
// will crash with larger byte strings. Arguably that's something that should
// be tested, but _MulleObjC11LengthASCIIString may be fairly obscure to hit
// though.
//
+ (void) initialize
{
   struct _mulle_objc_universefoundationinfo   *config;

   if( self != [NSString class])
      return;

   [super initialize]; // get MulleObjCClassCluster initialize

   assert( _MULLE_OBJC_FOUNDATIONINFO_N_STRINGSUBCLASSES >= _NSStringClassClusterStringSizeMax);

   config = _mulle_objc_universe_get_universefoundationinfo( MulleObjCObjectGetUniverse( self));

   config->stringsubclasses[ 0] = NULL;
   config->stringsubclasses[ _NSStringClassClusterStringSize256OrLess] = [_MulleObjCTinyASCIIString class];
   config->stringsubclasses[ _NSStringClassClusterStringSizeOther]     = [_MulleObjCGenericASCIIString class];

#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
   config->stringsubclasses[ _NSStringClassClusterStringSize3]  = [_MulleObjC03LengthASCIIString class];
   config->stringsubclasses[ _NSStringClassClusterStringSize7]  = [_MulleObjC07LengthASCIIString class];
   config->stringsubclasses[ _NSStringClassClusterStringSize11] = [_MulleObjC11LengthASCIIString class];
   config->stringsubclasses[ _NSStringClassClusterStringSize15] = [_MulleObjC15LengthASCIIString class];
#endif
}


#pragma mark -
#pragma mark class cluster selection

static enum _NSStringClassClusterStringSize   MulleObjCStringClassIndexForLength( NSUInteger length)
{
   //
   // if we hit the length exactly then avoid adding extra 4 zero bytes
   // by using subclass. Diminishing returns with larger strings...
   // Depends also on the granularity of the mallocer
   //
   switch( length)
   {
      case 00 : return( _NSStringClassClusterStringSize0);
#ifdef HAVE_FIXED_LENGTH_ASCII_SUBCLASSES
      case 03 : return( _NSStringClassClusterStringSize3);
      case 07 : return( _NSStringClassClusterStringSize7);
      case 11 : return( _NSStringClassClusterStringSize11);
      case 15 : return( _NSStringClassClusterStringSize15);
#endif
   }
   if( length < 0x100 + 1)
      return( _NSStringClassClusterStringSize256OrLess);
   return( _NSStringClassClusterStringSizeOther);
}


NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s,
                                                       NSUInteger length)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   enum _NSStringClassClusterStringSize        classIndex;

   classIndex = MulleObjCStringClassIndexForLength( length);
   if( ! classIndex)
      return( @"");

   config = _mulle_objc_universe_get_universefoundationinfo( MulleObjCGetUniverse());
   return( [(Class) config->stringsubclasses[ classIndex] newWithASCIICharacters:s
                                                                          length:length]);
}


NSString  *MulleObjCNewASCIIStringWithUTF32Characters( mulle_utf32_t *s,
                                                       NSUInteger length)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   enum _NSStringClassClusterStringSize        classIndex;

   classIndex = MulleObjCStringClassIndexForLength( length);
   if( ! classIndex)
      return( @"");

   config = _mulle_objc_universe_get_universefoundationinfo( MulleObjCGetUniverse());
   return( [(Class) config->stringsubclasses[ classIndex] newWithUTF32Characters:s
                                                               length:length]);
}


# pragma mark - convenience constructors

+ (instancetype) string
{
   return( [[[self alloc] init] autorelease]);
}


+ (instancetype) stringWithCharacters:(unichar *) s
                              length:(NSUInteger) len;
{
   return( [[[self alloc] initWithCharacters:s
                                      length:len] autorelease]);
}


+ (instancetype) mulleStringWithCharactersNoCopy:(unichar *) s
                                      length:(NSUInteger) len
                                   allocator:(struct mulle_allocator *) allocator;
{
   return( [[[self alloc] mulleInitWithCharactersNoCopy:s
                                             length:len
                                          allocator:allocator] autorelease]);
}


+ (instancetype) stringWithUTF8String:(char *) s
{
   return( [[[self alloc] initWithUTF8String:s] autorelease]);
}


+ (instancetype) mulleStringWithUTF8Characters:(mulle_utf8_t *) s
                                    length:(NSUInteger) len
{
   return( [[[self alloc] mulleInitWithUTF8Characters:s
                                           length:len] autorelease]);
}


+ (instancetype) mulleStringWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                          length:(NSUInteger) len
                                       allocator:(struct mulle_allocator *) allocator
{
   assert( s);
   assert( len);

   return( [[[self alloc] mulleInitWithUTF8CharactersNoCopy:s
                                                length:len
                                             allocator:allocator] autorelease]);
}


+ (instancetype) stringWithString:(NSString *) s
{
   return( [[[self alloc] initWithString:s] autorelease]);
}



#pragma mark -
#pragma mark generic init


- (instancetype) initWithString:(NSString *) other
{
   char   *s;

   NSParameterAssert( [self __isClassClusterPlaceholderObject]);

   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}


#pragma mark -
#pragma mark generic code

- (NSString *) description
{
   return( self);
}


- (NSString *) mulleDebugContentsDescription
{
   return( self);
}


//
// default for sprintf (and exceptions ?)
//
- (char *) cStringDescription
{
  return( [self UTF8String]);
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
   assert( ! memchr( storage, 0, len));
}


- (void) mulleGetUTF8Characters:(mulle_utf8_t *) buf
                 maxLength:(NSUInteger) maxLength
{
   grab_utf8( self,
              _cmd,
              (mulle_utf8_t *) [self UTF8String],
              [self mulleUTF8StringLength],
              buf,
              maxLength);
}


// string always zero terminates
// buffer must be large enough to contain maxLength - 1 chars plus a
// terminating zero char (which this method adds).

- (NSUInteger) mulleGetUTF8String:(mulle_utf8_t *) buf
                   bufferSize:(NSUInteger) size
{
   NSUInteger   length;

   assert( buf);

   length = [self mulleUTF8StringLength];
   [self mulleGetUTF8Characters:buf
                  maxLength:size];

   if( length >= size)
      length = size - 1;
   buf[ length] = 0;

   return( length);
}


- (void) mulleGetUTF8String:(mulle_utf8_t *) buf
{
   [self mulleGetUTF8String:buf
             bufferSize:ULONG_MAX];
}


- (void) mulleGetUTF8Characters:(mulle_utf8_t *) buf
{
   [self mulleGetUTF8Characters:buf
                  maxLength:LONG_MAX];
}


- (void) getCharacters:(unichar *) buf;
{
   NSUInteger   length;

   length = [self length];
   [self getCharacters:buf
                 range:NSMakeRange( 0, length)];
}


- (mulle_utf8_t *) mulleFastASCIICharacters
{
   return( NULL);
}

//
// this could be non-ascii in case of compiler generated strings
//
- (mulle_utf8_t *) mulleFastUTF8Characters
{
   return( NULL);
}


- (char *) UTF8String
{
   return( "");  // subclasses improve this (except empty string)
}


- (NSUInteger) mulleUTF8StringLength
{
   return( mulle_utf8_strlen( (mulle_utf8_t *) [self UTF8String]));
}


+ (BOOL) mulleAreValidUTF8Characters:(mulle_utf8_t *) buf
                          length:(NSUInteger) len
{
   struct mulle_utf_information  info;

   if( mulle_utf8_information( buf, len, &info))
      return( NO);

   return( YES);
}


#pragma mark -
#pragma mark substringing

- (NSString *) substringFromIndex:(NSUInteger) index
{
   return( [self substringWithRange:NSMakeRange( index, [self length] - index)]);
}


- (NSString *) substringToIndex:(NSUInteger) index
{
   return( [self substringWithRange:NSMakeRange( 0, index)]);
}


- (NSString *) substringWithRange:(NSRange) range
{
   struct mulle_allocator   *allocator;
   void                     *bytes;
   NSUInteger               length;

   length = [self length];
   MulleObjCValidateRangeWithLength( range, length);

   allocator = MulleObjCObjectGetAllocator( self);
   bytes     = mulle_allocator_malloc( allocator, range.length * sizeof( unichar));

   [self getCharacters:bytes
                 range:range];

   return( [[[NSString alloc] mulleInitWithCharactersNoCopy:bytes
                                                 length:range.length
                                              allocator:allocator] autorelease]);
}



//***************************************************
// LAYER 4 - code that works "optimally" on all
//           subclasses and probably need not be
//           overridden
//***************************************************
/*
 * some generic stuff, irregardless of UTF or C
 */

#pragma mark - hash and equality

// subclasses do it better usually
- (NSUInteger) hash
{
   return( MulleObjCStringHash( (mulle_utf8_t *) [self UTF8String], [self mulleUTF8StringLength]));
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSString])
      return( NO);
   return( [self isEqualToString:other]);
}


- (id) copy
{
   return( [self retain]);
}


#pragma mark -
#pragma mark case conversion

// ctype_convert will always add a zero (at buf[ len])
static mulle_utf8_t   *ctype_convert( mulle_utf8_t *src,
                                      NSUInteger len,
                                      NSRange range,
                                      int (*f_conversion)( int),
                                      struct mulle_allocator *allocator)
{
   mulle_utf8_t   *buf;
   mulle_utf8_t   *p;
   mulle_utf8_t   *sentinel;
   size_t         rest;

   buf      = mulle_allocator_malloc( allocator, len + 1);

   p        = &buf[ range.location];
   sentinel = &p[ range.length];
   while( p < sentinel)
      *p++ = (mulle_utf8_t) (*f_conversion)( (char) *src++);

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
   mulle_utf8_t             *buf;
   mulle_utf8_t             *s;
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);

   len = [self mulleUTF8StringLength];
   s   = [self mulleFastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                        len,
                        NSMakeRange( 0, len),
                        mulle_utf32_tolower,
                        allocator);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                              length:len + 1
                                           allocator:allocator]);
}


- (NSString *) uppercaseString
{
   NSUInteger               len;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *s;
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);

   len = [self mulleUTF8StringLength];
   s   = [self mulleFastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                        len,
                        NSMakeRange( 0, len),
                        mulle_utf32_toupper,
                        allocator);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                              length:len + 1
                                           allocator:allocator]);
}


- (NSString *) capitalizedString
{
   NSUInteger               len;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *s;
   struct mulle_allocator   *allocator;

   allocator = MulleObjCObjectGetAllocator( self);

   len = [self mulleUTF8StringLength];
   s   = [self mulleFastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                       len,
                       NSMakeRange( 0, 1),
                       mulle_utf32_totitlecase,
                       allocator);

   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                              length:len + 1
                                           allocator:allocator]);
}


#pragma mark -
#pragma mark numerical values

static mulle_utf8_t   *UTF8StringWithLeadingSpacesRemoved( NSString *self)
{
   mulle_utf8_t   *s;
   mulle_utf8_t   *old;
   unichar        c;

   s = (mulle_utf8_t *) [self UTF8String];
   assert( s);

   while( *s)
   {
      old = s;
      c   = _mulle_utf8_next_utf32character( &s);

      if( ! mulle_utf32_is_whitespace( c))
         return( old);
   }
   return( s);
}


- (double) doubleValue
{
   return( strtod( (char *) UTF8StringWithLeadingSpacesRemoved( self), NULL));
}


- (float) floatValue
{
   return( strtof( (char *) UTF8StringWithLeadingSpacesRemoved( self), NULL));
}


- (int) intValue
{
   return( (int) strtol( (char *) UTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (long long) longLongValue;
{
   return( strtoll( (char *) UTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (NSInteger) integerValue
{
   return( strtol( (char *) UTF8StringWithLeadingSpacesRemoved( self), NULL, 0));
}


- (BOOL) boolValue
{
   char  *s;

   s = (char *) UTF8StringWithLeadingSpacesRemoved( self);

   if( *s == '+' || *s == '-')
      ++s;
   while( *s == '0')
      ++s;

   switch( *s)
   {
   case '1' :
   case '2' :
   case '3' :
   case '4' :
   case '5' :
   case '6' :
   case '7' :
   case '8' :
   case '9' :
   case 'Y' :
   case 'y' :
   case 'T' :
   case 't' :
      return( YES);
   }
   return( NO);
}

@end
