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
   MulleObjCTaggedPointerRegisterClassAtIndex( self, 0x2);
}


- (int32_t) _int32Value     { return( (int32_t) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (int64_t) _int64Value     { return( (int64_t) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (BOOL) boolValue          { return( _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self) ? YES : NO); }
- (char) charValue          { return( (char) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (short) shortValue        { return( (short) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (int) intValue            { return( (int) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long) longValue          { return( (long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (NSInteger) integerValue  { return( (NSInteger) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long long) longLongValue { return( (long long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }

- (double) doubleValue            { return( (double) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }
- (long double) longDoubleValue   { return( (long double) _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self)); }


- (void) getValue:(void *) value
{
   *(NSInteger *) value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
}


- (mulle_objc_superquad) _superquadValue
{
   mulle_objc_superquad  value;
   NSInteger             v;
   
   v        = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   value.lo = v;
   value.hi = (v < 0) ? -1 : 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( NSInteger));
}


#pragma mark -
#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *) coder
{
   char        *type;
   NSInteger   value;
   
   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);
   
   type = @encode( NSInteger);
   [coder encodeBytes:type
               length:sizeof( @encode( NSInteger))];
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end
