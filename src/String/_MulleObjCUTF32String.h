//
//  MulleObjCUTF32String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

@interface _MulleObjCUTF32String : NSString

@end


@interface _MulleObjCUTF32String( _Subclasses)

+ (id) stringWithUTF16String:(utf16char *) bytes
                      length:(NSUInteger) length;
                    
@end


@interface _MulleObjCGenericUTF32String : _MulleObjCUTF32String
{
   utf8char     *_shadow;
   NSUInteger   _length;         // 257-max
   utf32char    _storage[ 1];
}
@end
