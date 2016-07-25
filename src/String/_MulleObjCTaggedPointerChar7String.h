//
//  _MulleObjCTaggedPointerASCIIString.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

#include <mulle_utf/mulle_utf.h>
#include <assert.h>


@interface _MulleObjCTaggedPointerChar7String : NSString < MulleObjCTaggedPointer>
@end


NSString  *MulleObjCTaggedPointerChar7StringWithASCIICharacters( char *s, NSUInteger length);


static inline NSString   *_MulleObjCTaggedPointerChar7StringFromValue( uintptr_t value)
{
   return( (NSString *) MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( value, 0x3));
}


static inline uintptr_t  _MulleObjCTaggedPointerChar7ValueFromString( NSString *obj)
{
   return( MulleObjCTaggedPointerGetUnsignedIntegerValue( obj));
}
