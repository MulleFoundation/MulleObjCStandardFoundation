//
//  _MulleObjCConcreteRangeCharacterSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 15.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSCharacterSet.h"


@interface _MulleObjCConcreteRangeCharacterSet : NSCharacterSet
{
   NSRange   _range;
   int       _rval;
}

+ (id) newWithRange:(NSRange) range
             invert:(BOOL) invert;

@end
