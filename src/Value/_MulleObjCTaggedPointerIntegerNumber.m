//
//  _MulleObjCConcreteIntegerNumber.m
//  MulleObjCFoundation
//
//  Created by Nat! on 23.07.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCTaggedPointerIntegerNumber.h"


@implementation _MulleObjCTaggedPointerIntegerNumber

+ (void) load
{
   MulleObjCTaggedPointerRegisterClassAtIndex( self, 3);
}

- (int32_t) _int32Value     {  return( (int32_t) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (int64_t) _int64Value     {  return( (int64_t) _MulleObjCConcreteIntegerValueFromNumber( self)); }

- (BOOL) boolValue          { return( _MulleObjCConcreteIntegerValueFromNumber( self) ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (short) shortValue        { return( (short) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (int) intValue            { return( (int) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (long) longValue          { return( (long) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCConcreteIntegerValueFromNumber( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCConcreteIntegerValueFromNumber( self)); }

- (double) doubleValue            { return( (double) _MulleObjCConcreteIntegerValueFromNumber( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCConcreteIntegerValueFromNumber( self)); }


- (void) getValue:(void *) value
{
   *(NSInteger *) value = _MulleObjCConcreteIntegerValueFromNumber( self);
}


- (mulle_objc_superquad) _superquadValue
{
   mulle_objc_superquad  value;
   
   value.lo = _MulleObjCConcreteIntegerValueFromNumber( self);
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( NSInteger));
}

@end
