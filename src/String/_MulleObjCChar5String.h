//
//  _MulleObjCChar5String.h
//  MulleObjCFoundation
//
//  Created by Nat! on 10.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

#include <mulle_utf/mulle_utf.h>
#include <assert.h>

// Char5Characters is a subset of ASCII that fits into 5 bits
//
//       0,
//      '.', '0', '1', '2', 'A', 'C', 'E', 'I',
//      'L', 'M', 'P', 'R', 'S', 'T', '_', 'a',
//      'b', 'c', 'd', 'e', 'g', 'i', 'l', 'm',
//      'n', 'o', 'p', 'r', 's', 't', 'u'
//
// this class is mainly used in tagged pointers, it's a bit weird.
// the 'self' contains the actual string and the isa only exists in
// the runtime
//
@interface _MulleObjCChar5String : NSString < MulleObjCTaggedPointer>
@end


NSString  *MulleObjCChar5StringWithChar5Characters( char *s, NSUInteger length);

static inline NSString   *_MulleObjCChar5StringFromValue( uintptr_t value)
{
   return( (NSString *) MulleObjCCreateTaggedPointerWithUnsignedIntegerValueAndIndex( value, 0x1));
}


static inline uintptr_t  _MulleObjCChar5ValueFromString( NSString *obj)
{
   return( MulleObjCTaggedPointerGetUnsignedIntegerValue( obj));
}
