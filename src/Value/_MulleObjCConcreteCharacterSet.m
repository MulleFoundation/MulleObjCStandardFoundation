//
//  _MulleObjCConcreteCharacterSet.m
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

#import "_MulleObjCConcreteCharacterSet.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation _MulleObjCConcreteCharacterSet


static int   first_plane_only( unsigned int plane)
{
   return( plane == 0);
}


+ (instancetype) newWithMemberFunction:(int (*)( unichar)) f
                         planeFunction:(int (*)( unsigned int)) plane_f
                                invert:(BOOL) invert
{
   _MulleObjCConcreteCharacterSet   *obj;

   // known to be all zeroed out(!) important!
   obj            = NSAllocateObject( self, 0, NULL);
   obj->_f        = f;
   obj->_plane_f  = plane_f ? plane_f : first_plane_only;
   obj->_invert   = invert;
   return( obj);
}


- (BOOL) characterIsMember:(unichar) c
{
   return( (*_f)( c) != _invert);
}


- (BOOL) longCharacterIsMember:(long) c
{
   return( (*_f)( (unichar) c) != _invert);
}


- (BOOL) hasMemberInPlane:(NSUInteger) plane
{
   return( (*_plane_f)( (unsigned int) plane) != _invert);
}


- (NSCharacterSet *) invertedSet
{
   return( [[_MulleObjCConcreteCharacterSet newWithMemberFunction:_f
                                                    planeFunction:_plane_f
                                                           invert:! _invert] autorelease]);
}


- (void) mulleGetBitmapBytes:(unsigned char *) bytes
                       plane:(NSUInteger) plane
{
   mulle_utf32_t   c;
   mulle_utf32_t   end;
   unsigned char   value;

   c   = plane * 0x10000;
   end = c + 0x10000;
   for( ; c < end; c += 8)
   {
      value = (unsigned char)
       (((*_f)(c + 0) != _invert ? (1 << 0) : 0) |
        ((*_f)(c + 1) != _invert ? (1 << 1) : 0) |
        ((*_f)(c + 2) != _invert ? (1 << 2) : 0) |
        ((*_f)(c + 3) != _invert ? (1 << 3) : 0) |
        ((*_f)(c + 4) != _invert ? (1 << 4) : 0) |
        ((*_f)(c + 5) != _invert ? (1 << 5) : 0) |
        ((*_f)(c + 6) != _invert ? (1 << 6) : 0) |
        ((*_f)(c + 7) != _invert ? (1 << 7) : 0));
      *bytes++ = value;
   }
}


@end
