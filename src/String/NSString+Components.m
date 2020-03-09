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
#import "NSCharacterSet.h"
#import "NSString+Search.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationContainer.h"
#import "MulleObjCStandardFoundationException.h"

// std-c and other dependencies
#import "import-private.h"


@implementation NSString ( Components)


static NSString   *makeUTF8String( mulle_utf8_t *s, NSUInteger len)
{
   if( ! len)
      return( @"");
   return( [[NSString alloc] mulleInitWithUTF8Characters:s
                                             length:len]);
}


static NSArray  *
   newArrayFromOffsetsAndUnicharBufWithSeperatorLen( Class arrayCls,
                                                     mulle_utf8_t *buf,
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
   struct mulle_allocator   *allocator;

   NSCParameterAssert( bufLen >= 1);
   NSCParameterAssert( sepLen >= 1);

   allocator = MulleObjCClassGetAllocator( arrayCls);
   strings   = mulle_allocator_malloc( allocator, (nOffsets + 1) * sizeof( NSString *));

   /* create strings for offsets make a little string of it and place it in
      strings array
     */
   p = buf;
   for( i = 0; i < nOffsets; i++)
   {
      q           = &buf[ offsets[ i]];
      NSCParameterAssert( q > p);
      len         = q - p - sepLen;
      strings[ i] = makeUTF8String( p, len);
      p           = q;
   }

   q             = &buf[ bufLen];
   len           = q - p;
   strings[ i++] = makeUTF8String( p, len);

   array = [[arrayCls alloc] mulleInitWithRetainedObjectStorage:strings
                                                          count:i
                                                           size:i];
   return( array);
}


id   _MulleObjCComponentsSeparatedByString( NSString *self,
                                            NSString *separator,
                                            Class arrayCls)
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
         array = newArrayFromOffsetsAndUnicharBufWithSeperatorLen( arrayCls, buf, n, offsets, i, m);
      mulle_free( tofree);
   }
   return( [array autorelease]);
}



NSArray  *MulleObjCComponentsSeparatedByString( NSString *self,
                                                NSString *separator)
{
   return( _MulleObjCComponentsSeparatedByString( self, separator, [NSArray class]));
}


NSMutableArray  *MulleObjCMutableComponentsSeparatedByString( NSString *self,
                                                              NSString *separator)
{
   return( _MulleObjCComponentsSeparatedByString( self, separator, [NSMutableArray class]));
}


- (NSArray *) componentsSeparatedByString:(NSString *) separator
{
   NSArray  *components;

   if( ! separator)
      MulleObjCThrowInvalidArgumentException( @"separator can't be nil");

   components = MulleObjCComponentsSeparatedByString( self, separator);
   if( ! components)
      components = [NSArray arrayWithObject:self];
   return( components);
}


- (NSMutableArray *) mulleMutableComponentsSeparatedByString:(NSString *) separator
{
   NSMutableArray  *components;

   if( ! separator)
      MulleObjCThrowInvalidArgumentException( @"separator can't be nil");

   components = MulleObjCMutableComponentsSeparatedByString( self, separator);
   if( ! components)
      components = [NSMutableArray arrayWithObject:self];
   return( components);
}


- (NSArray *) _componentsSeparatedByString:(NSString *) separator
{
   return( MulleObjCComponentsSeparatedByString( self, separator));
}


id   _MulleObjCComponentsSeparatedByCharacterSet( NSString *self,
                                                  NSCharacterSet *separators,
                                                  Class arrayCls)
{
   IMP               isMember;
   mulle_utf8_t      *buf;
   mulle_utf8_t      *p;
   mulle_utf8_t      *sentinel;
   mulle_utf8_t      *sep;
   NSArray           *array;
   NSUInteger        *offsets;
   NSUInteger        *tofree;
   NSUInteger        i, n;
   NSUInteger        m;
   NSUInteger        max;
   size_t            size;

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
         array = newArrayFromOffsetsAndUnicharBufWithSeperatorLen( arrayCls, buf, n, offsets, i, m);
      mulle_free( tofree);
   }
   return( [array autorelease]);
}


NSArray  *MulleObjCComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators)
{
   return( _MulleObjCComponentsSeparatedByCharacterSet( self, separators, [NSArray class]));
}


NSMutableArray  *MulleObjCMutableComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators)
{
   return( _MulleObjCComponentsSeparatedByCharacterSet( self, separators, [NSMutableArray class]));
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

- (NSMutableArray *) mulleMutableComponentsSeparatedByCharactersInSet:(NSCharacterSet *) separators
{
   NSMutableArray   *array;

   array = MulleObjCMutableComponentsSeparatedByCharacterSet( self, separators);
   if( ! array)
      array = [NSMutableArray arrayWithObject:self];
   return( array);
}


static NSMutableArray  *arrayWithComponents( NSArray *components, NSRange range, BOOL includeFirst)
{
   NSMutableArray   *array;

   array = [NSMutableArray array];
   if( includeFirst && range.location != 0)
      [array addObject:[components objectAtIndex:0]];
   [array addObjectsFromArray:[components subarrayWithRange:range]];
   return( array);
}


- (NSString *) mulleStringBySimplifyingComponentsSeparatedByString:(NSString *) separator
                                                      simplifyDots:(BOOL) simplifyDots
{
   enum
   {
      isUnknown,
      isAbsolute,
      isDot,
      isDotDot
   } pathtype;

   BOOL         skipping;
   id           result;
   NSArray      *components;
   NSString     *prev;
   NSString     *s;
   NSUInteger   i, n;
   NSUInteger   len;
   NSUInteger   start;

   //
   // if this is nil, path has no @"/" anywhere
   //
   components = [self _componentsSeparatedByString:separator];
   if( ! components)
      return( self);

   pathtype = isUnknown;
   skipping = YES;
   result   = nil;
   start    = 0;

   n = [components count];
   for( i = 0; i < n; i++)
   {
      s   = [components objectAtIndex:i];
      len = [s length];

         // if path starts with '/' or '.' we can collapse '..'
      if( ! len || (simplifyDots && [@"." isEqualToString:s]))
      {
         if( ! i)
            pathtype = ! len ? isAbsolute : isDot;

         // skip over '//' and '/./'
         if( skipping)
            ++start;
         continue;
      }

      // convert "/foo/../" to "foo"
      // though symlinks should be resolved now

      if( simplifyDots && [@".." isEqualToString:s])
      {
         if( ! i)
         {
            pathtype = isDotDot;
            ++start;    // still update this for later output
            skipping = NO;
            continue;
         }

         if( skipping && isAbsolute)
         {
            if( skipping)
               ++start;    // collapse /.. to /
            continue;
         }

         if( ! result)
            result = arrayWithComponents( components, NSMakeRange( start, i - start), YES);

         prev = [result lastObject];
         if( ! [@".." isEqualToString:prev])
         {
            if( ! [prev length])
               continue;

            [result removeLastObject];
            if( ! [result count])
            {
               result = nil;
               start  = i;
            }
            continue;
         }
      }

      // keep adding to nil, if there was nothing to collapse
      if( ! result && start)
         result = arrayWithComponents( components, NSMakeRange( start, i - start), YES);
      [result addObject:s];
      skipping = NO;
   }

   if( start == i)
   {
      switch( pathtype)
      {
         case isAbsolute : return( separator);
         case isDot      : return( @".");
         case isDotDot   : return( @"..");
         default         : break;
      }
   }
   if( ! result && ! start)
      return( self);

   if( ! result)
      result = arrayWithComponents( components, NSMakeRange( start, i - start), YES);

   // remove trailing '/' if any
   len = [result count];
   while( len)
   {
      s = [result lastObject];
      if( [s length] && (! simplifyDots || ! [s isEqualToString:@"."]))
         break;
      [result removeLastObject];
      --len;
   }

   if( ! len)
   {
      switch( pathtype)
      {
         case isAbsolute : return( separator);
         case isDot      : return( @".");
         case isDotDot   : return( @"..");
         default         : break;
      }
   }

   return( [result componentsJoinedByString:separator]);
}

@end
