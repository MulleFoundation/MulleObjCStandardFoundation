//
//  MulleObjCUTF16String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

#include <mulle_utf/mulle_utf.h>


//
// these UTF16 classes do not store a trailing zero, but the
// shadow UTF8 string will have one, for UTF8String
// access
//
@interface _MulleObjCUTF16String: NSString
{
   mulle_utf8char_t   *_shadow;
   NSUInteger         _length;
}

- (mulle_utf16char_t *) _fastUTF16StringContents;
- (mulle_utf8char_t *) _fastUTF8StringContents;
- (NSUInteger) _UTF16StringLength;
- (mulle_utf8char_t *) UTF8String;

@end


@interface _MulleObjCUTF16String( _Subclasses)

+ (id) newWithUTF16Characters:(mulle_utf16char_t *) bytes
                       length:(NSUInteger) length;

@end


@interface _MulleObjCGenericUTF16String : _MulleObjCUTF16String
{
   mulle_utf16char_t    _storage[ 1];
}
@end


@interface _MulleObjCAllocatorUTF16String  : _MulleObjCUTF16String
{
   mulle_utf16char_t        *_storage;
   struct mulle_allocator   *_allocator;
}

+ (id) newWithUTF16CharactersNoCopy:(void *) bytes
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator;

@end

