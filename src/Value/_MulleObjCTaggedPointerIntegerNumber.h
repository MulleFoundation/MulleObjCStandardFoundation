//
//  _MulleObjCConcreteIntegerNumber.h
//  MulleObjCFoundation
//
//  Created by Nat! on 23.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber.h"
//
// this has limited value range
//
@interface _MulleObjCTaggedPointerIntegerNumber : NSNumber < MulleObjCTaggedPointer>
@end


static inline NSNumber   *_MulleObjCConcreteIntegerNumberFromInteger( NSInteger value)
{
   return( (NSNumber *) MulleObjCCreateTaggedPointerWithIntegerValueAndIndex( value, 0x2));
}


static inline NSInteger  _MulleObjCConcreteIntegerValueFromNumber( NSNumber *obj)
{
   return( MulleObjCTaggedPointerGetIntegerValue( obj));
}


static inline NSNumber   *_MulleObjCConcreteUnsignedIntegerNumberFromUnsignedInteger( NSUInteger value)
{
   return( (NSNumber *) MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( value, 0x2));
}


static inline NSUInteger  _MulleObjCConcreteUnsignedIntegerValueFromNumber( NSNumber *obj)
{
   return( MulleObjCTaggedPointerGetUnsignedIntegerValue( obj));
}
