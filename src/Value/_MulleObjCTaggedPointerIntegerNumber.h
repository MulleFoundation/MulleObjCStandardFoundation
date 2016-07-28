//
//  _MulleObjCTaggedPointerIntegerNumber.h
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


static inline NSNumber   *_MulleObjCTaggedPointerIntegerNumberWithInteger( NSInteger value)
{
   return( (NSNumber *) MulleObjCCreateTaggedPointerWithIntegerValueAndIndex( value, 0x2));
}


static inline NSInteger  _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( _MulleObjCTaggedPointerIntegerNumber *obj)
{
   return( MulleObjCTaggedPointerGetIntegerValue( obj));
}
