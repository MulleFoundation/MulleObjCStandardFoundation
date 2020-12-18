//
//  _MulleObjCConcreteBitmapCharacterSet.m
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

#import "_MulleObjCConcreteInvertedCharacterSet.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and dependencies


@implementation _MulleObjCConcreteInvertedCharacterSet


+ (instancetype) newWithCharacterSet:(NSCharacterSet *) other
{
   _MulleObjCConcreteInvertedCharacterSet   *obj;

   obj = NSAllocateObject( self, 0, NULL);
   obj->_original = [other copy];

   return( obj);
}


- (void) dealloc
{
   [_original release];

   [super dealloc];
}


- (BOOL) characterIsMember:(unichar) c
{
   if( c >= 0x110000)
      return( NO);
   return( ! [_original characterIsMember:c]);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   if( plane >= 0x11)
      return( NO);
   return( ! [_original hasMemberInPlane:plane]);
}


static int   mulle_meminvert_8( uint8_t *buf, size_t length)
{
   uint8_t   *p;
   uint8_t   *sentinel;
   uint8_t   bits;

   bits     = 0;
   p        = buf;
   sentinel = &p[ length];
   while( p < sentinel)
   {
      bits |= (*p = ~*p);
      ++p;
   }

   return( (int) bits);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   if( ! bytes)
      MulleObjCThrowInvalidArgumentException( @"empty bytes");
   if( plane >= 0x11)
      MulleObjCThrowInvalidArgumentException( @"excessive plane index");

   [_original mulleGetBitmapBytes:bytes
                            plane:plane];

   mulle_meminvert_8( bytes, 8192);
}


- (NSCharacterSet *) invertedSet
{
   return( _original);
}

@end
