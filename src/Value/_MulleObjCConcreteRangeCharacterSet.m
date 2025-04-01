//
//  _MulleObjCConcreteRangeCharacterSet.m
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

#import "_MulleObjCConcreteRangeCharacterSet.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteRangeCharacterSet

+ (instancetype) newWithRange:(NSRange) range
                       invert:(BOOL) invert;
{
   _MulleObjCConcreteRangeCharacterSet   *obj;

   // known to be all zeroed out(!) important!
   obj           = NSAllocateObject( self, 0, NULL);
   obj->_range   = range;
   obj->_invert  = invert;
   return( obj);
}


- (BOOL) characterIsMember:(unichar) c
{
   if( (uint32_t) c >= 0x110000)
      return( NO);

   return( NSLocationInRange( c, _range) == ! _invert);
}


- (BOOL) longCharacterIsMember:(long) c
{
   if( (uint32_t) c >= 0x110000)
      return( NO);

   return( NSLocationInRange( c, _range)  == ! _invert);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   NSRange   planeRange;

   if( plane >= 0x11)
      return( 0);

   planeRange.location = plane * 0x10000;
   planeRange.length   = 0x10000;
   return( (NSIntersectionRange( _range, planeRange).length != 0) == ! _invert);
}


- (NSCharacterSet *) invertedSet
{
   return( [[_MulleObjCConcreteRangeCharacterSet newWithRange:_range
                                                       invert:! _invert] autorelease]);
}

@end
