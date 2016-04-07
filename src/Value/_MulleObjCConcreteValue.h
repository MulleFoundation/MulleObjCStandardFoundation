//
//  _MulleObjCConcreteValue.h
//  MulleObjCFoundation
//
//  Created by Nat! on 18.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSValue.h"


@interface _MulleObjCConcreteValue : NSValue
{
   NSUInteger  _size;
}

+ (id) valueWithBytes:(void *) bytes
             objCType:(char *) type;
@end
