//
//  NSString.m
//  MulleObjCFoundation
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

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"

// std-c and dependencies
#include <mulle_utf/mulle_utf.h>
#include <ctype.h>

#if MULLE_UTF_VERSION < ((1 << 20) | (0 << 8) | 0)
# error "mulle_utf is too old"
#endif


@implementation NSObject( _NSString)

- (BOOL) __isNSString
{
   return( NO);
}

@end


@implementation NSString


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
   struct _ns_rootconfiguration   *config;

   config = _ns_get_rootconfiguration();
   config->string.charsfromobject = (char *(*)()) stringToUTF8;
   config->string.objectfromchars = (void *(*)()) UTF8ToString;
}


- (BOOL) __isNSString
{
   return( YES);
}


+ (id) string
{
   return( [[[self alloc] init] autorelease]);
}


+ (id) stringWithCharacters:(unichar *) s
                     length:(NSUInteger) len;
{
   return( [[[self alloc] initWithCharacters:s
                                      length:len] autorelease]);
}


+ (id) _stringWithCharactersNoCopy:(unichar *) s
                            length:(NSUInteger) len
                         allocator:(struct mulle_allocator *) allocator;
{
   return( [[[self alloc] _initWithCharactersNoCopy:s
                                             length:len
                                          allocator:allocator] autorelease]);
}


+ (id) stringWithUTF8String:(char *) s
{
   return( [[[self alloc] initWithUTF8String:s] autorelease]);
}


+ (id) _stringWithUTF8Characters:(mulle_utf8_t *) s
                         length:(NSUInteger) len
{
   return( [[[self alloc] _initWithUTF8Characters:s
                                           length:len] autorelease]);
}


+ (id) _stringWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                length:(NSUInteger) len
                             allocator:(struct mulle_allocator *) allocator
{
   assert( s);
   assert( len);

   return( [[[self alloc] _initWithUTF8CharactersNoCopy:s
                                                length:len
                                             allocator:allocator] autorelease]);
}


+ (id) stringWithString:(NSString *) s
{
   return( [[[self alloc] initWithString:s] autorelease]);
}



#pragma mark -
#pragma mark generic init


- (id) initWithString:(NSString *) other
{
   char   *s;

   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}


#pragma mark -
#pragma mark generic code

- (id) description
{
   return( self);
}


- (NSString *) _debugContentsDescription
{
   return( self);
}


- (NSUInteger) hash
{
   NSRange   range;
   char      *s;

   range = MulleObjCHashRange( [self _UTF8StringLength]);
   s     = [self UTF8String];
   return( MulleObjCStringHash( &s[ range.location], range.length));
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


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
                 maxLength:(NSUInteger) maxLength
{
   grab_utf8( self,
              _cmd,
              (mulle_utf8_t *) [self UTF8String],
              [self _UTF8StringLength],
              buf,
              maxLength);
}


// string always zero terminates
// buffer must be large enough to contain maxLength - 1 chars plus a
// terminating zero char (which this method adds).

- (NSUInteger) _getUTF8String:(mulle_utf8_t *) buf
                   bufferSize:(NSUInteger) size
{
   NSUInteger   length;

   assert( buf);

   length = [self _UTF8StringLength];
   [self _getUTF8Characters:buf
                  maxLength:size];

   if( length >= size)
      length = size - 1;
   buf[ length] = 0;

   return( length);
}


- (void) _getUTF8String:(mulle_utf8_t *) buf
{
   [self _getUTF8String:buf
             bufferSize:ULONG_MAX];
}


- (void) _getUTF8Characters:(mulle_utf8_t *) buf
{
   [self _getUTF8Characters:buf
                  maxLength:LONG_MAX];
}


- (void) getCharacters:(unichar *) buf;
{
   NSUInteger   length;

   length = [self length];
   [self getCharacters:buf
                 range:NSMakeRange( 0, length)];
}


- (mulle_utf8_t *) _fastUTF8Characters
{
   return( NULL);
}


- (char *) UTF8String
{
   return( "");  // subclasses improve this (except empty string)
}


- (NSUInteger) _UTF8StringLength
{
   return( mulle_utf8_strlen( (mulle_utf8_t *) [self UTF8String]));
}


+ (BOOL) _areValidUTF8Characters:(mulle_utf8_t *) buf
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
   if( range.location + range.length > length || range.length > length)
      MulleObjCThrowInvalidRangeException( range);

   allocator = MulleObjCObjectGetAllocator( self);
   bytes     = mulle_allocator_malloc( allocator, range.length * sizeof( unichar));

   [self getCharacters:bytes
                 range:range];

   return( [[[NSString alloc] _initWithCharactersNoCopy:bytes
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

   len = [self _UTF8StringLength];
   s   = [self _fastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                        len,
                        NSMakeRange( 0, len),
                        mulle_utf32_tolower,
                        allocator);
   return( [NSString _stringWithUTF8CharactersNoCopy:buf
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

   len = [self _UTF8StringLength];
   s   = [self _fastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                        len,
                        NSMakeRange( 0, len),
                        mulle_utf32_toupper,
                        allocator);
   return( [NSString _stringWithUTF8CharactersNoCopy:buf
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

   len = [self _UTF8StringLength];
   s   = [self _fastUTF8Characters];
   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];
   buf = ctype_convert( s,
                       len,
                       NSMakeRange( 0, 1),
                       mulle_utf32_totitlecase,
                       allocator);

   return( [NSString _stringWithUTF8CharactersNoCopy:buf
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
