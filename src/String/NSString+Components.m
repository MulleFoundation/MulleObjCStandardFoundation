//
//  NSString+Components.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
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
#import "NSString+Components.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"

// std-c and other dependencies


@implementation NSString ( Components)


static NSString   *makeUTF8String( mulle_utf8_t *s, NSUInteger len)
{
   if( ! len)
      return( @"");
   return( [[NSString alloc] _initWithUTF8Characters:s
                                             length:len]);
}


static NSArray  *newArrayFromOffsetsAndUnicharBufWithSeperatorLen( mulle_utf8_t *buf,
                                                                   NSUInteger bufLen,
                                                                   NSUInteger *offsets,
                                                                   NSUInteger nOffsets,
                                                                   NSUInteger sepLen)
{
   NSArray                  *array;
   NSString                 **strings;
   NSUInteger               i;
   mulle_utf8_t             *p;
   mulle_utf8_t             *q;
   NSUInteger               len;
   Class                    arrayCls;
   struct mulle_allocator   *allocator;

   NSCParameterAssert( bufLen >= 1);
   NSCParameterAssert( sepLen >= 1);

   arrayCls  = [NSArray class];
   allocator = MulleObjCClassGetAllocator( arrayCls);
   strings   = mulle_allocator_malloc( allocator, (nOffsets + 1) * sizeof( NSString *));

   /* create strings for offsets make a little string of it and place it in
      strings array
     */
   p = buf;
   for( i = 0; i < nOffsets; i++)
   {
      q   = &buf[ offsets[ i]];
      NSCParameterAssert( q > p);
      len = q - p - sepLen;
      strings[ i] = makeUTF8String( p, len);
      p = q;
   }

   q   = &buf[ bufLen];
   len = q - p;
   strings[ i++] = makeUTF8String( p, len);

   array = [[arrayCls alloc] mulleInitWithRetainedObjectStorage:strings
                                                          count:i
                                                          size:i];
   return( array);
}


NSArray  *MulleObjCComponentsSeparatedByString( NSString *self, NSString *separator)
{
   NSUInteger        i, n;
   NSUInteger        m;
   NSUInteger        max;
   NSUInteger        remain;
   NSArray           *array;
   mulle_utf8_t      *buf;
   mulle_utf8_t      *sep;
   mulle_utf8_t      sepChar;
   mulle_utf8_t      *sentinel;
   mulle_utf8_t      *p;
   mulle_utf8_t      *q;
   NSUInteger        *offsets;
   NSUInteger        *tofree;
   int               diff;
   size_t            size;

   n = [self mulleUTF8StringLength];
   if( ! n)
      return( nil);   // not the same as Objective-C (!) see below

   // stay compatible to foundation
   m = [separator mulleUTF8StringLength];
   if( ! m)
      return( nil);

#if DEBUG_VERBOSE
   fprintf( stderr, "string=\"%s\" separator=\"%s\"\n", [self cString], [separator cString]);
#endif
   //
   // for really huge strings, we might want to choose a different
   // batching algorithm. But for EOF, strings are mostly small
   //
   max  = (n + (m - 1)) / m + 2;
   size = (n + m) * sizeof( mulle_utf8_t) + max * sizeof( NSUInteger);
   {
      NSUInteger   tmp[ 0x20];

      tofree  = NULL;
      offsets = tmp;
      if( size > sizeof( NSUInteger) * 0x20)
         tofree = offsets = mulle_malloc( size);
      buf = (mulle_utf8_t *) &offsets[ max];
      sep = (mulle_utf8_t *) &buf[ n];

      [self mulleGetUTF8Characters:buf];
      sentinel = &buf[ n];

      // Degenerate case @"." -> ( @"", @"")

      i = 0;
      // simpler algorithm, if m is just a character
      if( m == 1)
      {
         sepChar = (mulle_utf8_t) [separator characterAtIndex:0];

         for( p = buf; p < sentinel;)
         {
            if( *p++ != sepChar)
               continue;

            offsets[ i++] = p - buf;
         }
      }
      else
      {
         [separator mulleGetUTF8Characters:sep];

         remain = m;
         p      = buf;
         q      = sep;

         while( p < sentinel)
         {
            if( *p++ == *q)
            {
               ++q;
               if( --remain)
                  continue;

               // matched whole string
               // memorize that
               offsets[ i++] = p - buf;

               remain = m;
               q      = sep;
               continue;
            }

            diff = (int) remain - (int) m;
            if( ! diff)
               continue;

            p      = &p[ diff];
            q      = sep;
            remain = m;
         }
      }

      // 95% of all cases, there is no separator in self
      array = nil;
      if( i)
         array = newArrayFromOffsetsAndUnicharBufWithSeperatorLen( buf, n, offsets, i, m);
      mulle_free( tofree);
   }
   return( [array autorelease]);
}


- (NSArray *) componentsSeparatedByString:(NSString *) separator
{
   NSArray  *components;

   components = MulleObjCComponentsSeparatedByString( self, separator);
   if( ! components)
      components = [NSArray arrayWithObject:self];
   return( components);
}


- (NSArray *) _componentsSeparatedByString:(NSString *) separator
{
   return( MulleObjCComponentsSeparatedByString( self, separator));
}



NSArray  *MulleObjCComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators)
{
   NSUInteger        i, n;
   NSUInteger        m;
   NSUInteger        max;
   NSArray           *array;
   mulle_utf8_t      *buf;
   mulle_utf8_t      *sep;
   mulle_utf8_t      *sentinel;
   mulle_utf8_t      *p;
   NSUInteger        *offsets;
   NSUInteger        *tofree;
   size_t            size;
   IMP               isMember;

   n = [self mulleUTF8StringLength];
   if( ! n)
      return( nil);   // not the same as Objective-C (!) see below

   // stay compatible to foundation
   if( ! separators)
      return( nil);

   //
   // for really huge strings, we might want to choose a different
   // batching algorithm. But for EOF, strings are mostly small
   //
   m    = 1;
   max  = (n + (m - 1)) / m + 2;
   size = (n + m) * sizeof( mulle_utf8_t) + max * sizeof( NSUInteger);
   {
      NSUInteger   tmp[ 0x20];

      tofree  = NULL;
      offsets = tmp;
      if( size > sizeof( NSUInteger) * 0x20)
         tofree = offsets = mulle_malloc( size);
      buf = (mulle_utf8_t *) &offsets[ max];
      sep = (mulle_utf8_t *) &buf[ n];

      [self mulleGetUTF8Characters:buf];
      sentinel = &buf[ n];

      // Degenerate case @"." -> ( @"", @"")

      isMember = [separators methodForSelector:@selector( characterIsMember:)];
      i = 0;
      for( p = buf; p < sentinel;)
      {
         if( ! (*isMember)( separators, @selector( characterIsMember:), (id) (uintptr_t) *p++))
            continue;

         offsets[ i++] = p - buf;
      }

      // 95% of all cases, there is no separator in self
      array = nil;
      if( i)
         array = newArrayFromOffsetsAndUnicharBufWithSeperatorLen( buf, n, offsets, i, m);
      mulle_free( tofree);
   }
   return( [array autorelease]);
}

// will return nil, if not separated! (to be compatible)
- (NSArray *) _componentsSeparatedByCharacterSet:(NSCharacterSet *) separators
{
   return( MulleObjCComponentsSeparatedByCharacterSet( self, separators));
}


- (NSArray *) componentsSeparatedByCharactersInSet:(NSCharacterSet *) separators
{
   NSArray   *array;

   array = MulleObjCComponentsSeparatedByCharacterSet( self, separators);
   if( ! array)
      array = [NSArray arrayWithObject:self];
   return( array);
}

@end
