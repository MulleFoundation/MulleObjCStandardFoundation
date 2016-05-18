//
//  _MulleObjCConcreteNumber.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber.h"


@interface _MulleObjCInt8Number : NSNumber
{
   int8_t  _value;
}

+ (id) newWithInt8:(int8_t) value;

@end


@interface _MulleObjCInt16Number : NSNumber
{
   int16_t  _value;
}

+ (id) newWithInt16:(int16_t) value;

@end


@interface _MulleObjCInt32Number : NSNumber
{
   int32_t  _value;
}

+ (id) newWithInt32:(int32_t) value;

@end


@interface _MulleObjCInt64Number : NSNumber
{
   int64_t  _value;
}

+ (id) newWithInt64:(int64_t) value;

@end


#pragma mark -
#pragma mark unsigned variants (8/16 superflous)


@interface _MulleObjCUInt32Number : NSNumber
{
   uint32_t  _value;
}

+ (id) newWithUInt32:(uint32_t) value;

@end


@interface _MulleObjCUInt64Number : NSNumber
{
   uint64_t  _value;
}

+ (id) newWithUInt64:(uint64_t) value;

@end


// assume float losslessly converts to double and back
@interface _MulleObjCDoubleNumber : NSNumber
{
   double   _value;
}

+ (id) newWithDouble:(double) value;

@end


@interface _MulleObjCLongDoubleNumber : NSNumber
{
   long double   _value;
}

+ (id) newWithLongDouble:(long double) value;

@end
