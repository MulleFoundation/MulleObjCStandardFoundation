//
//  _MulleObjCConcreteNumber.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber.h"


@interface _MulleObjCIntegerNumber : NSNumber
{
   NSInteger  _value;
}
@end


// assume float losslessly converts to double and back
@interface _MulleObjCDoubleNumber : NSNumber
{
   double   _value;
}
@end


@interface _MulleObjCLongLongNumber : NSNumber
{
   long long  _value;
}
@end

