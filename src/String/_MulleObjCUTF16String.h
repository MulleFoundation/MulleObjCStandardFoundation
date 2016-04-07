//
//  MulleObjCUTF16String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

#include <mulle_utf/mulle_utf.h>


@interface _MulleObjCUTF16String: NSString
@end


@interface _MulleObjCUTF16String( _Subclasses)

+ (id) stringWithUTF16String:(utf16char *) bytes
                      length:(NSUInteger) length;
                    
@end


@interface _MulleObjCGenericUTF16String : _MulleObjCUTF16String
{
   utf8char     *_shadow;
   NSUInteger   _length;         // 257-max
   utf16char    _storage[ 1];
}
@end
