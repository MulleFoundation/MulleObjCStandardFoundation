//
//  _MulleObjCUTF16String.h
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

//
// these UTF16 classes do not store a trailing zero, but the
// shadow UTF8 string will have one, for UTF8String
// access
//
@interface _MulleObjCUTF16String: NSString <MulleObjCImmutable>
{
   mulle_utf8_t   *_shadow;
   NSUInteger     _length;
}

- (mulle_utf16_t *) _fastUTF16Characters;
- (mulle_utf8_t *) mulleFastUTF8Characters;
- (NSUInteger) _UTF16StringLength;
- (mulle_utf8_t *) UTF8String;

@end


@interface _MulleObjCUTF16String( _Subclasses)

+ (instancetype) newWithUTF16Characters:(mulle_utf16_t *) bytes
                                 length:(NSUInteger) length;

@end


@interface _MulleObjCGenericUTF16String : _MulleObjCUTF16String
{
   mulle_utf16_t    _storage[ 1];
}
@end


@interface _MulleObjCAllocatorUTF16String  : _MulleObjCUTF16String
{
   mulle_utf16_t            *_storage;
   struct mulle_allocator   *_allocator;
}

+ (instancetype) newWithUTF16CharactersNoCopy:(void *) bytes
                                       length:(NSUInteger) length
                                    allocator:(struct mulle_allocator *) allocator;

@end


@interface _MulleObjCSharedUTF16String : _MulleObjCUTF16String
{
   mulle_utf16_t   *_storage;
   id               _sharingObject;
}

+ (instancetype) newWithUTF16CharactersNoCopy:(mulle_utf16_t *) chars
                                        length:(NSUInteger) length
                                 sharingObject:(id) sharingObject;
@end
