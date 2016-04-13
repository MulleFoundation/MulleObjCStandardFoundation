//
//  MulleObjCUTF32String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

@interface _MulleObjCUTF32String : NSString
{
   mulle_utf8char_t    *_shadow;
   NSUInteger          _length;         // 257-max
}
@end


@interface _MulleObjCUTF32String( _Subclasses)

+ (id) newWithUTF32Characters:(mulle_utf32char_t *) chars
                       length:(NSUInteger) length;

@end


@interface _MulleObjCGenericUTF32String : _MulleObjCUTF32String
{
   mulle_utf32char_t   _storage[ 1];
}
@end


@interface _MulleObjCAllocatorUTF32String  : _MulleObjCUTF32String
{
   mulle_utf32char_t        *_storage;
   struct mulle_allocator   *_allocator;
}

+ (id) newWithUTF32CharactersNoCopy:(mulle_utf32char_t *) chars
                             length:(NSUInteger) length
                          allocator:(struct mulle_allocator *) allocator;

@end

