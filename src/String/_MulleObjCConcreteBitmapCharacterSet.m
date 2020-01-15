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

#import "_MulleObjCConcreteBitmapCharacterSet.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardFoundationException.h"

// std-c and dependencies


@implementation _MulleObjCConcreteBitmapCharacterSet


+ (instancetype) newWithBitmapRepresentation:(NSData *) data
{
   _MulleObjCConcreteBitmapCharacterSet   *obj;
   struct mulle_allocator                 *allocator;

   obj       = NSAllocateObject( self, 0, NULL);
   allocator = MulleObjCObjectGetAllocator( obj);
   if( MulleObjCCharacterBitmapInitWithBitmapRepresentation( &obj->_bitmap, data, allocator))
   {
      [obj release];
      return( nil);
   }
   return( obj);
}


+ (instancetype) newWithString:(NSString *) s
{
   _MulleObjCConcreteBitmapCharacterSet   *obj;

   obj = NSAllocateObject( self, 0, NULL);
   MulleObjCCharacterBitmapSetBitsWithString( &obj->_bitmap, s, MulleObjCObjectGetAllocator( obj));

   return( obj);
}


- (void) dealloc
{
   MulleObjCCharacterBitmapFreePlanes( &self->_bitmap, MulleObjCObjectGetAllocator( self));

   [super dealloc];
}


- (BOOL) characterIsMember:(unichar) c
{
   int   bit;

   if( c >= 0x110000)
      return( NO);

   bit = MulleObjCCharacterBitmapGetBit( &self->_bitmap, c);
   return( bit);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   if( plane >= 0x11)
      return( NO);

   return( _bitmap.planes[ plane] != NULL);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   if( ! bytes)
      MulleObjCThrowInvalidArgumentException( @"empty bytes");
   if( plane >= 0x11
)
      MulleObjCThrowInvalidArgumentException( @"excessive plane index");

   if( _bitmap.planes[ plane])
      memcpy( bytes, _bitmap.planes[ plane], 8192);
   else
      memset( bytes, 0, 8192);
}

@end
