/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSString.h"

// other files in this library
#import "NSString+ClassCluster.h"
#import "NSString+Search.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"

// std-c and dependencies
#include <mulle_utf/mulle_utf.h>
#include <ctype.h>


@implementation NSObject( _NSString)

- (BOOL) __isNSString
{
   return( NO);
}

@end


@implementation NSString


static mulle_utf8_t   *stringToUTF8( NSString *s)
{
   return( [s UTF8String]);
}


static NSString   *UTF8ToString( mulle_utf8_t *s)
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


+ (id) stringWithUTF8String:(mulle_utf8_t *) s
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
   mulle_utf8_t    *s;
   
   s = [other UTF8String];
   return( [self initWithUTF8String:s]);
}


#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSString class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   void         *bytes;
   NSUInteger   length;
   
   bytes = [coder decodeBytesWithReturnedLength:&length];
   return( [self _initWithUTF8Characters:bytes
                                  length:length]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   mulle_utf8_t   *bytes;
   NSUInteger     length;
   
   bytes  = [self UTF8String];
   length = [self _UTF8StringLength];
   [coder encodeBytes:bytes
               length:length + 1];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
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
   NSRange        range;
   mulle_utf8_t   *s;
   
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
              [self UTF8String],
              [self _UTF8StringLength],
              buf,
              maxLength);
}


// string always zero terminates
// buffer must be large enough to contain maxLength chars plus a
// terminating zero char (which this method adds).

- (void) getUTF8String:(mulle_utf8_t *) buf
             maxLength:(NSUInteger) maxLength
{
   NSUInteger   length;
   
   assert( buf);
   
   length = [self _UTF8StringLength];
   [self _getUTF8Characters:buf
                 maxLength:maxLength];
   if( length > maxLength)
      length = maxLength;

   buf[ length] = 0;
}


- (void) getUTF8String:(mulle_utf8_t *) buf
{
   [self getUTF8String:buf
             maxLength:ULONG_MAX];
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


- (mulle_utf8_t *) UTF8String
{
   return( (mulle_utf8_t *) "");  // subclasses improve this (except empty string)
}


- (NSUInteger) _UTF8StringLength
{
   return( mulle_utf8_strlen( [self UTF8String]));
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
      s = [self UTF8String];
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
      s = [self UTF8String];
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
      s = [self UTF8String];
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
   
   s = [self UTF8String];
   assert( s);
   
   while( *s)
   {
      old = s;
      c   = _mulle_utf8_next_utf32_char( &s);
      
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
