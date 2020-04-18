//
//  NSCharacterSet.m
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
#pragma clang diagnostic ignored "-Wparentheses"

#import "NSCharacterSet.h"

// other files in this library
#import "_MulleObjCConcreteCharacterSet.h"
#import "_MulleObjCConcreteBitmapCharacterSet.h"
#import "_MulleObjCConcreteRangeCharacterSet.h"
#import "_MulleObjCConcreteInvertedCharacterSet.h"

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies
#include <ctype.h>


@implementation NSCharacterSet

+ (instancetype) alphanumericCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isalnum
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) controlCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:iscntrl
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) decimalDigitCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isdigit
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) letterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isalpha
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) lowercaseLetterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:islower
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) punctuationCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:ispunct
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) symbolCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isgraph
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) uppercaseLetterCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isupper
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) whitespaceAndNewlineCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:isspace
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}

static int  x_iswhite( int c)
{
   switch( c)
   {
   case ' '  :
   case '\t' :
      return( 1);
   }
   return( 0);
}


+ (instancetype) whitespaceCharacterSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:x_iswhite
                                                    planeFunction:0
                                                           invert:NO] autorelease]);
}


+ (instancetype) characterSetWithCharactersInString:(NSString *) s
{
   return( [[_MulleObjCConcreteBitmapCharacterSet newWithString:s] autorelease]);
}


/*
 *
 */
- (instancetype) invertedSet
{
   return( [[_MulleObjCConcreteInvertedCharacterSet newWithCharacterSet:self] autorelease]);
}


- (BOOL) isSupersetOfSet:(NSCharacterSet *) set
{
   unsigned int   i;
   long           c;

   // trivial check
   if( self == set)
      return( YES);

   if( ! set)
      return( YES);  // i guess

   // simplistic easy check
   for( i = 0; i <= 0x10; i++)
      if( [set hasMemberInPlane:i] && ! [self hasMemberInPlane:i])
         return( NO);

   // ultra layme
   for( c = 0; c <= mulle_utf32_max; c++)
      if( [self longCharacterIsMember:c] != [set longCharacterIsMember:c])
         return( NO);

   return( YES);
}


- (BOOL) longCharacterIsMember:(long) c
{
   return( [self characterIsMember:(unichar) c]);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   long   c;
   long   end;

   c   = plane * 0x10000;
   end = c + 0x10000;
   for( ; c < end; c += 8)
   {
      *bytes++ = (unsigned char)
      (([self longCharacterIsMember:c] << 0) |
       ([self longCharacterIsMember:c + 1] << 1) |
       ([self longCharacterIsMember:c + 2] << 2) |
       ([self longCharacterIsMember:c + 3] << 3) |
       ([self longCharacterIsMember:c + 4] << 4) |
       ([self longCharacterIsMember:c + 5] << 5) |
       ([self longCharacterIsMember:c + 6] << 6) |
       ([self longCharacterIsMember:c + 7] << 7));
   }
}


- (instancetype) initWithBitmapRepresentation:(NSData *) data
{
   id   old;

   old  = self;
   self = [_MulleObjCConcreteBitmapCharacterSet newWithBitmapRepresentation:data];
   [old release];
   return( self);
}


- (NSData *) bitmapRepresentation
{
   unsigned char   planes[ 0x11];
   unsigned int    i;
   unsigned int    extra;
   NSMutableData   *data;
   unsigned char   *p;

   extra = 0;
   for( i = 1; i < 0x11; i++)
      if( planes[ i] = [self hasMemberInPlane:i])
         ++extra;

   data  = [NSMutableData dataWithLength:8192 + (extra * 8193)];
   p     = [data mutableBytes];

   [self mulleGetBitmapBytes:p
                       plane:0];
   p = &p[ 8192];

   for( i = 1; i < 0x11; i++)
   {
      if( ! planes[ i])
         continue;

      *p++ = i;

      [self mulleGetBitmapBytes:p
                     plane:i];
      p = &p[ 8192];
   }

   return( data);
}


static inline void    _mulle__buffer_add_unichar( struct mulle__buffer *buffer,
                                                  unichar c,
                                                  struct mulle_allocator *allocator)
{
   unsigned char   *p;

   if( _mulle__buffer_guarantee( buffer, 4, allocator))
      return;

   p = (unsigned char *) &c;

   *buffer->_curr++ = *p++;
   *buffer->_curr++ = *p++;
   *buffer->_curr++ = *p++;
   *buffer->_curr++ = *p++;
}


static inline void    mulle_buffer_add_unichar( struct mulle_buffer *buffer,
                                                unichar c)
{
   if( ! buffer)
      return;

   _mulle__buffer_add_unichar( (struct mulle__buffer *) buffer,
                               c,
                               mulle_buffer_get_allocator( buffer));
}


static NSString *
   NSCharacterSetDescriptionWithSeparatorCharacter( NSCharacterSet *self,
                                                    unichar separator)
{
   struct mulle_buffer      buffer;
   struct mulle_allocator   *allocator;
   uint8_t                  *bitmap;
   uint8_t                  byte;
   unsigned int             i, j, k;
   uint8_t                  bit;
   unichar                  c;
   unichar                  *characters;
   size_t                   length;

   allocator = MulleObjCClassGetAllocator( [NSString class]);
   mulle_buffer_init( &buffer, allocator);

   bitmap = mulle_malloc( 8192);
   for( i = 0; i < 0x11; i++)
   {
      if( ! [self hasMemberInPlane:i])
         continue;

      [self mulleGetBitmapBytes:bitmap
                     plane:i];

      for( j = 0; j < 8192; j++)
      {
         if( ! (byte = bitmap[ j]))
            continue;

         for( k = 0; k < 8; k++)
         {
            bit = 1 << k;
            if( ! (byte & bit))
               continue;

            c = k + j * 8 + i * 65536;

            if( separator && mulle_buffer_get_length( &buffer))
               mulle_buffer_add_unichar( &buffer, separator);
            mulle_buffer_add_unichar( &buffer, c);
         }
      }
   }
   mulle_free( bitmap);

   length     = mulle_buffer_get_length( &buffer) / sizeof( unichar);
   characters = mulle_buffer_extract_all( &buffer);
   mulle_buffer_done( &buffer);

   return( [NSString mulleStringWithCharactersNoCopy:characters
                                              length:length
                                           allocator:allocator]);
}


- (NSString *) description
{
   return( NSCharacterSetDescriptionWithSeparatorCharacter( self, 0));
}


- (NSString *) mulleTestDescription
{
   return( NSCharacterSetDescriptionWithSeparatorCharacter( self, '\n'));
}


- (id) copy
{
   return( [self retain]);
}

@end
