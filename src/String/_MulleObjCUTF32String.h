//
//  _MulleObjCUTF32String.h
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


@interface _MulleObjCUTF32String : NSString < MulleObjCImmutable>
{
   mulle_utf8_t    *_shadow;
   NSUInteger      _length;         // 257-max
}
@end


@interface _MulleObjCUTF32String( _Subclasses)

+ (instancetype) newWithUTF32Characters:(mulle_utf32_t *) chars
                                 length:(NSUInteger) length;

@end


@interface _MulleObjCGenericUTF32String : _MulleObjCUTF32String
{
   mulle_utf32_t   _storage[ 1];
}
@end


@interface _MulleObjCAllocatorUTF32String  : _MulleObjCUTF32String
{
   mulle_utf32_t            *_storage;
   struct mulle_allocator   *_allocator;
}

+ (instancetype) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator;

@end


@interface _MulleObjCSharedUTF32String  : _MulleObjCUTF32String
{
   mulle_utf32_t   *_storage;
   id               _sharingObject;
}

+ (instancetype) newWithUTF32CharactersNoCopy:(mulle_utf32_t *) chars
                                       length:(NSUInteger) length
                                sharingObject:(id) sharingObject;
@end


// TODO: need a string that references an immutable owner
//       that provides the storage (with an offset)
//
