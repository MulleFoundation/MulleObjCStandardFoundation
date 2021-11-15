//
//  NSString+Escaping.m
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

#import "NSString+Escaping.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+Components.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and dependencies
#include <ctype.h>


// what's the point of this warning, anyway ?
#pragma clang diagnostic ignored "-Wint-to-void-pointer-cast"


#define MULLE_PLIST_DECODE_NSNUMBER  // needed for "loose"


@implementation NSString (Escaping)


#pragma mark - escape

static inline mulle_utf8_t   hex( mulle_utf8_t c)
{
   assert( c >= 0 && c <= 0xf);
   return( c >= 0xa ? c + 'a' - 0xa : c + '0');
}


static inline int   dehexnybble( mulle_utf8_t c)
{
   if( c >= '0' && c <= '9')
      return( c - '0');
   if( c >= 'a' && c <= 'f')
      return( c - 'a' + 10);
   if( c >= 'A' && c <= 'F')
      return( c - 'A' + 10);
   return( -1);
}


static int   dehexbyte( mulle_utf8_t c, mulle_utf8_t d)
{
   int   value1, value2;

   value1 = dehexnybble( c);
   if( value1 < 0)
      return( value1);
   value2 = dehexnybble( d);
   if( value2 < 0)
      return( value2);

   return( (value1 << 4) | value2);
}


//
// This does common C escapes like tab into \t
// If the unicode character is not printable we use octal, otherwise keep
// UTF8 as is.
//
char   *MulleUTF8StringEscape( char *src, NSUInteger length, char *dst)
{
   mulle_utf8_t            c;
   mulle_utf8_t            *start;
   mulle_utf8_t            *s;
   mulle_utf8_t            *sentinel;
   mulle_utf32_t           utf32;
   ptrdiff_t               i;
   ptrdiff_t               len;
   struct mulle_utf8data   rover;

#ifndef NDEBUG
   mulle_utf8_t            *dst_sentinel;

   dst_sentinel = &dst[ length * 4];
#endif

   s        = src;
   sentinel = &s[ length];
   while( s < sentinel)
   {
      c = *s++;
      switch( c)
      {
         case '\a' : *dst++ = '\\'; *dst++ = 'a'; continue;
         case '\b' : *dst++ = '\\'; *dst++ = 'b'; continue;
         case '\e' : *dst++ = '\\'; *dst++ = 'e'; continue;
         case '\f' : *dst++ = '\\'; *dst++ = 'f'; continue;
         case '\n' : *dst++ = '\\'; *dst++ = 'n'; continue;
         case '\r' : *dst++ = '\\'; *dst++ = 'r'; continue;
         case '\t' : *dst++ = '\\'; *dst++ = 't'; continue;
         case '\v' : *dst++ = '\\'; *dst++ = 'v'; continue;
         case '?'  : *dst++ = '\\'; *dst++ = '?'; continue;  // trigraph
         case '\\' : *dst++ = '\\'; *dst++ = '\\'; continue;
         case '"'  : *dst++ = '\\'; *dst++ = '"'; continue;
         default   : if( c >= 0x20 && c < 0x7F)  // easy "printable ASCII check"
                     {
                        *dst++ = c;
                        continue;
                     }
      }

      //
      // compose utf32 character, check if its is "printable"
      // -> not part of control character set+
      //
      start            = &s[ -1];

      rover.characters = start;
      rover.length     = sentinel - start;

      utf32 = _mulle_utf8data_next_utf32character( &rover);
      if( (int32_t) utf32 < 0)
      {
         // kinda super broken so, what now ?
         *dst++ = '\\';
         *dst++ = (((unsigned char) c >> 6) & 0x7) + '0';
         *dst++ = (((unsigned char) c >> 3) & 0x7) + '0';
         *dst++ = (((unsigned char) c >> 0) & 0x7) + '0';
         continue;
      }

      if( mulle_unicode_is_control( utf32))
      {
         // escape them all
         len = rover.characters - start;
         for( i = 0; i < len; i++)
         {
            c      = start[ i];
            *dst++ = '\\';
            *dst++ = (((unsigned char) c >> 6) & 0x7) + '0';
            *dst++ = (((unsigned char) c >> 3) & 0x7) + '0';
            *dst++ = (((unsigned char) c >> 0) & 0x7) + '0';
         }
      }
      else
      {
         dst = mulle_utf32_as_utf8( utf32, dst);
      }

      // dial forwards
      s = rover.characters;
   }
   assert( dst <= dst_sentinel);

   return( dst);
}


//
// This does common C escapes like tab into \t
// If the unicode character is not printable we use octal, otherwise keep
// UTF8 as is.
//
char   *MulleUTF8StringUnescape( char *src, NSUInteger length, char *dst)
{
   mulle_utf8_t            c;
   mulle_utf8_t            d;
   mulle_utf8_t            e;
   mulle_utf8_t            *start;
   mulle_utf8_t            *s;
   mulle_utf8_t            *sentinel;
   mulle_utf32_t           utf32;
   ptrdiff_t               i;
   ptrdiff_t               len;
   int                     value;
   struct mulle_utf8data   rover;

   s        = src;
   sentinel = &s[ length];
   while( s < sentinel)
   {
      c = *s++;
      if( c != '\\')
      {
         *dst++ = c;
         continue;
      }

      if( s >= sentinel)
         goto fail;

      c = *s++;
      switch( c)
      {
      default   : *dst++ = c; break;

      case '0'  :
      case '1'  :
      case '2'  :
      case '3'  :
      case '4'  :
      case '5'  :
      case '6'  :
      case '7'  :
         d     = 0;
         e     = 0;
         value = -1;
         if( s < sentinel)
         {
            if( isdigit( *s))
            {
               d = *s++;
               if( s < sentinel)
               {
                  if( isdigit( *s))
                  {
                     e = *s++;
                     value = ((c - '0') << 6) | ((d - '0') << 3) | (e - '0');
                  }
               }
               else
                  value = ((c - '0') << 3) | (d - '0');
            }
         }
         if( value < 0)
            value = c - '0';
         *dst++ = value;
         break;


      // hex is so stupid, we don't do it like C, we just parse 2
      case 'x'  :
         if( s + 2 > sentinel)
            goto fail;
         value = dehexbyte( s[ 0], s[ 1]);
         if( value < 0)
            goto fail;
         *dst++ = value;
         s += 2;
         break;

      case 'a'  : *dst++ = '\a'; break;
      case 'b'  : *dst++ = '\b'; break;
      case 'e'  : *dst++ = '\e'; break;
      case 'f'  : *dst++ = '\f'; break;
      case 'n'  : *dst++ = '\n'; break;
      case 'r'  : *dst++ = '\r'; break;
      case 't'  : *dst++ = '\t'; break;
      case 'v'  : *dst++ = '\v'; break;
      case '?'  : *dst++ = '?';  break;
      case '\\' : *dst++ = '\\'; break;
      case '\'' : *dst++ = '\''; break;
      case '\"' : *dst++ = '\"'; break;
      }
   }
   return( dst);

fail:
   *dst++ = '?';
   return( dst);
}



// C escaped but not quotes added
- (NSString *) mulleEscapedString
{
   struct mulle_allocator   *allocator;
   NSUInteger               dst_length;
   NSUInteger               length;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *dst;
   mulle_utf8_t             *s;
   mulle_utf8_t             c;
   size_t                   size;

   length = [self mulleUTF8StringLength];
   if( ! length)
      return( @"");

   allocator = MulleObjCInstanceGetAllocator( self);
   size      = length * 4 + 1;
   buf       = (mulle_utf8_t *) mulle_allocator_malloc( allocator, size);

   // place source in the back of our buffer
   // then quote from the start
   s        = &buf[ length * 3 + 1];
   dst      = buf;

   [self mulleGetUTF8Characters:s
                      maxLength:length];
   dst    = MulleUTF8StringEscape( s, length, dst);
   *dst++ = 0;
   assert( dst <= &buf[ size]);

   dst_length = dst - buf;
   buf        = mulle_allocator_realloc( allocator, buf, dst_length);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                                  length:dst_length
                                               allocator:allocator]);
}


// C escaped but not quotes added
- (NSString *) mulleUnescapedString
{
   struct mulle_allocator   *allocator;
   NSUInteger               dst_length;
   NSUInteger               length;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *dst;
   mulle_utf8_t             *s;
   mulle_utf8_t             c;
   size_t                   size;

   length = [self mulleUTF8StringLength];
   if( ! length)
      return( @"");

   allocator = MulleObjCInstanceGetAllocator( self);
   size      = length * 2 + 1;
   buf       = (mulle_utf8_t *) mulle_allocator_malloc( allocator, size);

   // place source in the back of our buffer
   s        = &buf[ length + 1];
   dst      = buf;

   [self mulleGetUTF8Characters:s
                      maxLength:length];
   dst    = MulleUTF8StringUnescape( s, length, dst);
   *dst++ = 0;

   dst_length = dst - buf;
   assert( dst_length <= size);
   buf        = mulle_allocator_realloc( allocator, buf, dst_length);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                                  length:dst_length
                                               allocator:allocator]);
}


// C escape quoting
- (NSString *) mulleQuotedString
{
   struct mulle_allocator   *allocator;
   NSUInteger               dst_length;
   NSUInteger               length;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *dst;
   mulle_utf8_t             *s;
   mulle_utf8_t             *sentinel;
   mulle_utf8_t             c;
   NSUInteger               size;

   length = [self mulleUTF8StringLength];
   if( ! length)
      return( @"\"\"");

   allocator = MulleObjCInstanceGetAllocator( self);

   // as we octal escape, worstcase is 4 times explosion
   size   = length * 4 + 3;
   buf    = (mulle_utf8_t *) mulle_allocator_malloc( allocator, size);
   dst    = buf;

   // place source in the back of our buffer
   // then quote from the start
   s      = &buf[ size - length];
   [self mulleGetUTF8Characters:s
                      maxLength:length];

   *dst++ = '\"';
   dst    = MulleUTF8StringEscape( s, length, dst);
   *dst++ = '\"';
   *dst++ = 0;

   dst_length = dst - buf;
   assert( dst_length <= size);
   buf        = mulle_allocator_realloc( allocator, buf, dst_length);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                                  length:dst_length
                                               allocator:allocator]);
}

- (NSString *) mulleUnquotedString
{
   struct mulle_allocator   *allocator;
   NSUInteger               dst_length;
   NSUInteger               length;
   NSUInteger               size;
   mulle_utf8_t             *buf;
   mulle_utf8_t             *dst;
   mulle_utf8_t             *s;
   mulle_utf8_t             c;

   length = [self mulleUTF8StringLength];
   if( length < 2)
      return( nil);

   allocator = MulleObjCInstanceGetAllocator( self);
   size      = length * 2 + 1;
   buf       = (mulle_utf8_t *) mulle_allocator_malloc( allocator, size);

   // place source in the back of our buffer
   s        = &buf[ size - length];
   dst      = buf;

   [self mulleGetUTF8Characters:s
                      maxLength:length];
   if( *s != '"' || s[ length - 1] != '"')
   {
      mulle_allocator_free( allocator, buf);
      return( nil);
   }

   dst    = MulleUTF8StringUnescape( s + 1, length - 2, dst);
   *dst++ = 0;

   dst_length = dst - buf;
   assert( dst_length <= size);
   buf        = mulle_allocator_realloc( allocator, buf, dst_length);
   return( [NSString mulleStringWithUTF8CharactersNoCopy:buf
                                                  length:dst_length
                                               allocator:allocator]);
}



- (NSString *) mulleDebugContentsDescription
{
   return( [self mulleQuotedString]);
}


- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters
{
   IMP            characterIsMemberIMP;
   NSUInteger     dst_length;
   NSUInteger     length;
   SEL            characterIsMemberSEL;
   mulle_utf8_t   *buf;
   mulle_utf8_t   *dst_buf;
   mulle_utf8_t   *p;
   mulle_utf8_t   *s;
   mulle_utf8_t   *sentinel;
   mulle_utf8_t   c;

   if( ! allowedCharacters)
      return( nil);

   length = [self mulleUTF8StringLength];
   if( ! length)
      return( self);

   buf = (mulle_utf8_t *) MulleObjCCallocAutoreleased( length, sizeof( mulle_utf8_t));
   [self mulleGetUTF8Characters:buf
                      maxLength:length];

   characterIsMemberSEL = @selector( characterIsMember:);
   characterIsMemberIMP = [allowedCharacters methodForSelector:characterIsMemberSEL];;

   dst_buf  = NULL;
   p        = NULL;
   s        = buf;
   sentinel = &s[ length];

   while( s < sentinel)
   {
      c = *s++;
      if( (*characterIsMemberIMP)( allowedCharacters, characterIsMemberSEL, (void *) c))
      {
         if( p)
            *p++ = c;
         continue;
      }

      if( ! p)
      {
         dst_buf    = MulleObjCCallocAutoreleased( length * 3, sizeof( mulle_utf8_t));
         dst_length = s - buf - 1;
         memcpy( dst_buf, buf, dst_length);
         p          = &dst_buf[ dst_length];
      }

      *p++ = '%';
      *p++ = hex( c >> 4);
      *p++ = hex( c & 0xF);
   }

   if( ! dst_buf)
      return( self);

   return( [NSString mulleStringWithUTF8Characters:dst_buf
                                            length:p - dst_buf]);
}



#pragma mark - unescape


static id   always_no( id obj, SEL sel, void *param)
{
   return( (id) NO);
}


static inline int   dehex( mulle_utf8_t c)
{
   if( c >= '0' && c <= '9')
      return( c - '0');

   if( c >= 'A' && c <= 'Z')
      return( c - 'a' + 10);

   if( c >= 'a' && c <= 'z')
      return( c - 'a' + 10);

   return( -1);  // two wrongs will make a "right"
}


//
// returns NULL of string has invalid percentescapes
// otherwise returns converted string in mulle_utf8data
// may not be \0 terminated though
//
struct mulle_utf8data  *_MulleReplacePercentEscape( struct mulle_utf8data *src,
                                                    NSCharacterSet *disallowedCharacters)
{
   IMP                      characterIsMemberIMP;
   SEL                      characterIsMemberSEL;
   mulle_utf8_t             *p;
   mulle_utf8_t             *s;
   mulle_utf8_t             *sentinel;
   mulle_utf8_t             c;
   struct mulle_utf8data   *dst;
   int                      hi, lo;

   characterIsMemberSEL = @selector( characterIsMember:);
   if( disallowedCharacters)
      characterIsMemberIMP = [disallowedCharacters methodForSelector:characterIsMemberSEL];
   else
      characterIsMemberIMP = (IMP) always_no;

   if( src->length == (size_t) -1)
      src->length = mulle_utf8_strlen( src->characters) + 1; // keep the \0

   dst      = NULL;
   p        = NULL;
   s        = src->characters;
   sentinel = &s[ src->length];

   while( s < sentinel)
   {
      c = *s++;
      if( c != '%')
      {
         if( p)
            *p++ = c;
         continue;
      }

      if( &s[ 2] > sentinel)
         return( NULL);

      hi = dehex( s[ 0]);
      lo = dehex( s[ 1]);

      if( hi < 0 || lo < 0)
         return( NULL);
      c = (mulle_utf8_t) (hi << 4 | lo);
      if( ! c)
         return( NULL);

      if( (*characterIsMemberIMP)( disallowedCharacters, characterIsMemberSEL, (void *) c))
         return( NULL);

      if( ! p)
      {
         dst             = MulleObjCCallocAutoreleased( 1, sizeof( *dst) + src->length * sizeof( mulle_utf8_t));
         dst->characters = (mulle_utf8_t *) (dst + 1);
         dst->length     = s - src->characters - 1;

         memcpy( dst->characters, src->characters, dst->length);
         p = &dst->characters[ dst->length];
      }

      *p++ = c;
      s   += 2;
   }

   if( ! dst)
      return( src);

   dst->length = p - dst->characters;
   return( dst);
}


NSString  *MulleObjCStringByReplacingPercentEscapes( NSString *self,
                                                     NSCharacterSet *disallowedCharacters)
{

   struct mulle_utf8data   src;
   struct mulle_utf8data   *dst;

   src.length = [self mulleUTF8StringLength];
   if( ! src.length)
      return( self);

   src.characters = (mulle_utf8_t *) MulleObjCCallocAutoreleased( src.length, sizeof( mulle_utf8_t));
   [self mulleGetUTF8Characters:src.characters
                      maxLength:src.length];
   dst = _MulleReplacePercentEscape( &src, disallowedCharacters);

   if( dst == &src)
      return( self);
   if( ! dst)
      return( nil);

   return( [NSString mulleStringWithUTF8Characters:dst->characters
                                            length:dst->length]);
}


- (NSString *) mulleStringByReplacingPercentEscapesWithDisallowedCharacters:(NSCharacterSet *) disallowedCharacters
{
   return( MulleObjCStringByReplacingPercentEscapes( self, disallowedCharacters));
}



- (NSString *) stringByRemovingPercentEncoding
{
   return( [self mulleStringByReplacingPercentEscapesWithDisallowedCharacters:nil]);
}



enum quoteState
{
   NeedsNothing          = 0x0,
   NeedsQuotes           = 0x1,
   NeedsQuotesAndEscapes = 0x2
};


- (enum quoteState) mulleNeedsQuotes
{
   mulle_utf8_t             *s;
   mulle_utf8_t             *sentinel;
   NSUInteger               len;
   enum quoteState          state;
   struct mulle_utf8data   data;

   s = NULL;
   if( [self mulleFastGetUTF8Data:&data])
   {
      s   = data.characters;
      len = data.length;
   }
   else
   {
      len = [self mulleUTF8StringLength];
   }

   if( ! len)
      return( NeedsQuotes);

   if( ! s)
      s = (mulle_utf8_t *) [self UTF8String];

   //
   // some specialties for property lists (need not be zero terminated)
   // we want to preserve the "stringness" of @"YES" (not @(YES))
   //
#ifdef MULLE_PLIST_DECODE_NSNUMBER
   if( len == 2 && ! memcmp( s, "NO", 2))
      return( NeedsQuotes);
   if( len == 3 && ! memcmp( s, "YES", 3))
      return( NeedsQuotes);

   state = NeedsNothing;
   if( isdigit( *s))
      state = NeedsQuotes;
#endif

   sentinel = &s[ len];
   while( s < sentinel)
   {
      switch( *s)
      {
         case '\a' :
         case '\b' :
         case '\e' :
         case '\f' :
         case '\n' :
         case '\r' :
         case '\t' :
         case '\v' :
         case '\?' :
         case '\\' :
         case '"'  : return( NeedsQuotesAndEscapes);

         default   :
            if( ! isalnum( *s))
               state = NeedsQuotes;
      }

      ++s;
   }
   return( state);
}


- (NSString *) mulleQuotedDescriptionIfNeeded
{
   NSString          *strings[ 3];
   NSMutableString   *s;

   switch( [self mulleNeedsQuotes])
   {
   case NeedsNothing:
      return( self);

   case NeedsQuotesAndEscapes :
      return( [self mulleQuotedString]);

   case NeedsQuotes:
      break;
   }

   strings[ 0] = @"\"";
   strings[ 1] = self;
   strings[ 2] = @"\"";

   s = [[[NSMutableString alloc] initWithStrings:strings
                                           count:3] autorelease];
   return( s);
}


- (NSString *) mulleStringByReplacingCharactersInSet:(NSCharacterSet *) set
                                       withCharacter:(unichar) c
{
   IMP                       characterIsMemberIMP;
   NSUInteger                length;
   unichar                   *buf;
   unichar                   *s;
   unichar                   *sentinel;
   unichar                   c;
   int                       replaced;
   struct mulle_allocator   *allocator;

   if( ! c || c >= 0x1F0000)
      return( nil);

   length = [self length];
   if( ! length)
      return( self);

   allocator = MulleObjCInstanceGetAllocator( self);
   buf       = mulle_allocator_malloc( allocator, length * sizeof( unichar));
   [self getCharacters:buf];

   characterIsMemberIMP = [set methodForSelector:@selector( characterIsMember:)];

   replaced = 0;
   s        = buf;
   sentinel = &s[ length];
   while( s < sentinel)
   {
      if( (*characterIsMemberIMP)( set, @selector( characterIsMember:), (void *) *s))
      {
         replaced = 1;
         *s       = c;
      }
      ++s;
   }

   if( ! replaced)
   {
      mulle_allocator_free( allocator, buf);
      return( self);
   }

   return( [NSString mulleStringWithCharactersNoCopy:buf
                                              length:length
                                           allocator:allocator]);
}
@end
