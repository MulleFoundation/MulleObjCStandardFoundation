//
//  _MulleObjCTaggedPointerChar5String.h
//  MulleObjCFoundation
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

#import "NSString.h"

#include <mulle_utf/mulle_utf.h>
#include <assert.h>

// Char5Characters is a subset of ASCII that fits into 5 bits
//
//       0,
//      '.', '0', '1', '2', 'A', 'C', 'E', 'I',
//      'L', 'M', 'P', 'R', 'S', 'T', '_', 'a',
//      'b', 'c', 'd', 'e', 'g', 'i', 'l', 'm',
//      'n', 'o', 'p', 'r', 's', 't', 'u'
//
// this class is mainly used in tagged pointers, it's a bit weird.
// the 'self' contains the actual string and the isa only exists in
// the runtime
//
@interface _MulleObjCTaggedPointerChar5String : NSString < MulleObjCTaggedPointer>
@end


NSString  *MulleObjCTaggedPointerChar5StringWithASCIICharacters( char *s, NSUInteger length);


static inline NSString   *_MulleObjCTaggedPointerChar5StringFromValue( NSUInteger value)
{
   return( (NSString *) MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( value, 0x1));
}


static inline NSUInteger  _MulleObjCTaggedPointerChar5ValueFromString( NSString *obj)
{
   return( MulleObjCTaggedPointerGetUnsignedIntegerValue( obj));
}
