/*
 *  MulleCore - Optimized Foundation Replacements and Extensions Functionality 
 *              also a part of MulleEOFoundation of MulleEOF (Project Titmouse) 
 *              which is part of the Mulle EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, Mulle kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSString+MulleFastComponents.m,v bc35f12316af 2011/03/23 14:35:34 nat $
 *
 *  $Log$
 */
#import "NSString+Components.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"

// std-c and other dependencies


#if DEBUG  // coz the stupid debugger trips up on alloca stack frames
# define mulle_safer_alloca( size)  ((void *) [[NSMutableData dataWithLength:size] mutableBytes])
#else
# define mulle_safer_alloca( size)  \
(size <= 0x400 ? alloca( size): (void *) [[NSMutableData dataWithLength:size] mutableBytes])
#endif


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
   NSArray            *array;
   NSString           **strings;
   NSUInteger         i;
   mulle_utf8_t   *p;
   mulle_utf8_t   *q;
   NSUInteger         len;
   
   NSCParameterAssert( bufLen >= 1);
   NSCParameterAssert( sepLen >= 1);
   
   strings = (NSString **) mulle_safer_alloca( (nOffsets + 1) * sizeof( NSString *));
   
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
   
   // would be nice if we could add them retained already...
   array = [[NSArray alloc] _initWithRetainedObjects:strings
                                               count:i];
   
   return( array);
}


NSArray  *MulleObjCComponentsSeparatedByString( NSString *self, NSString *separator)
{
   NSUInteger           i, n;
   NSUInteger           m;
   NSUInteger           max;
   NSUInteger           remain;
   NSArray              *array;
   mulle_utf8_t      *buf;
   mulle_utf8_t      *sep;
   mulle_utf8_t      sepChar;
   mulle_utf8_t      *sentinel;
   mulle_utf8_t      *p;
   mulle_utf8_t      *q;
   NSUInteger   *offsets;
   int          diff;
   
   n = [self _UTF8StringLength];
   if( ! n)
      return( nil);   // not the same as Objective-C (!) see below
   
   // stay compatible to foundation
   m = [separator _UTF8StringLength];
   if( ! m)
      return( nil);
   
#if DEBUG_VERBOSE
   fprintf( stderr, "string=\"%s\" separator=\"%s\"\n", [self cString], [separator cString]);
#endif   
   //
   // for really huge strings, we might want to choose a different
   // batching algorithm. But for EOF, strings are mostly small
   //
   buf = (mulle_utf8_t *) mulle_safer_alloca( n * sizeof( mulle_utf8_t));
   [self _getUTF8Characters:buf];
   sentinel = &buf[ n];

   // Degenerate case @"." -> ( @"", @"")
   max     = (n + (m - 1)) / m + 2;
   offsets = (NSUInteger *) mulle_safer_alloca( max * sizeof( NSUInteger));
   
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
      sep = (mulle_utf8_t *) mulle_safer_alloca( m * sizeof( mulle_utf8_t));
      [separator _getUTF8Characters:sep];

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
   if( ! i)
      return( nil);
   
   array = newArrayFromOffsetsAndUnicharBufWithSeperatorLen( buf, n, offsets, i, m);
   
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

@end
