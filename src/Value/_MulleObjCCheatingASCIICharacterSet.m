//
//  _MulleObjCCheatingASCIICharacterSet.m
//  MulleObjCValueFoundation
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
#import "NSCharacterSet.h"
#import "MulleObjCCharacterBitmap.h"

#import "_MulleObjCCheatingASCIICharacterSet.h"
#import "_MulleObjCConcreteInvertedCharacterSet.h"


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"


@implementation _MulleObjCCheatingASCIICharacterSet


+ (instancetype) alloc       { abort(); }
- (void) dealloc             { abort(); }
- (instancetype) autorelease { abort(); }
- (instancetype) retain      { abort(); }
- (void) release             { abort(); }


- (BOOL) characterIsMember:(unichar) c
{
   uint64_t   bit;

   if( (uint32_t) c >= 0x110000)
      return( NO);

   if( c >= 0x100)
      bit = 0;
   else
      bit = (_bits[ c >> 6] & 1ULL << (c & 0x3F));

   return( (bit != 0) ^ _invert);
}


- (BOOL) longCharacterIsMember:(long) c
{
   uint64_t   bit;

   if( c >= 0x110000)
      return( NO);

   if( (unsigned long) c >= 0x100)
      bit = 0;
   else
      bit = (_bits[ c >> 6] & 1ULL << (c & 0x3F));

   return( (bit != 0) ^ _invert);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   BOOL   flag;

   if( plane >= 0x11)
      return( NO);

   flag = plane == 0x0;
   return( flag ^ _invert);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   unsigned int  c;

   if( ! bytes)
      MulleObjCThrowInvalidArgumentException( @"empty bytes");
   if( plane >= 0x11)
      MulleObjCThrowInvalidArgumentException( @"excessive plane index");

   memset( bytes, _invert ? 0xFF : 0x00, 8192);
   if( plane == 0)
      for( c = 0; c < 0x100; c++)
         if( (_bits[ c >> 6] & 1ULL << (c & 0x3F)))
         {
            if( _invert)
               _mulle_uint32_bitmap_clr( (uint32_t *) bytes, c);
            else
               _mulle_uint32_bitmap_set( (uint32_t *) bytes, c);
         }
}


- (NSCharacterSet *) invertedSet
{
   // copy into "real" set then invert
   return( [[_MulleObjCConcreteInvertedCharacterSet newWithCharacterSet:[self immutableInstance]] autorelease]);
}


@end
