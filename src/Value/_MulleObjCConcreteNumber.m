//
//  _MulleObjCConcreteNumber.m
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteNumber.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation _MulleObjCInt8Number : NSNumber

+ (id) newWithInt8:(int8_t) value
{
   _MulleObjCInt8Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}

- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( _value); }
- (int) intValue            { return( _value); }
- (long) longValue          { return( _value); }
- (NSInteger) integerValue  { return( _value); }
- (long long) longLongValue { return( _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(int8_t *) value = _value;
}


- (char *) objCType
{
   return( @encode( int8_t));
}

@end


@implementation _MulleObjCInt16Number : NSNumber

+ (id) newWithInt16:(int16_t) value
{
   _MulleObjCInt16Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( _value); }
- (long) longValue          { return( _value); }
- (NSInteger) integerValue  { return( _value); }
- (long long) longLongValue { return( _value); }

- (unsigned char) unsignedCharValue   { return( (uint8_t) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(int16_t *) value = _value;
}


- (char *) objCType
{
   return( @encode( int16_t));
}

@end



@implementation _MulleObjCInt32Number : NSNumber

+ (id) newWithInt32:(int32_t) value
{
   _MulleObjCInt32Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( _value); }
- (long) longValue          { return( _value); }
- (NSInteger) integerValue  { return( _value); }
- (long long) longLongValue { return( _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(int32_t *) value = _value;
}


- (char *) objCType
{
   return( @encode( int32_t));
}

@end



@implementation _MulleObjCInt64Number

+ (id) newWithInt64:(int64_t) value
{
   _MulleObjCInt64Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}



- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t) _value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( _value); }
- (NSInteger) integerValue  { return( _value); }
- (long long) longLongValue { return( _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(long long *) value = _value;
}


- (char *) objCType
{
   return( @encode( int64_t));
}

@end


@implementation _MulleObjCUInt32Number : NSNumber

+ (id) newWithUInt32:(uint32_t) value
{
   _MulleObjCUInt32Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (int32_t) _int32Value     {  return( (int32_t) _value); }
- (int64_t) _int64Value     {  return( (int64_t)_value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( (long) _value); }
- (NSInteger) integerValue  { return( (NSInteger) _value); }
- (long long) longLongValue { return( (long long) _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }


- (void) getValue:(void *) value
{
   *(uint32_t *) value = _value;
}


- (mulle_objc_superquad) _superquadValue
{
   mulle_objc_superquad  value;
   
   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint32_t));
}

@end


@implementation _MulleObjCUInt64Number : NSNumber

+ (id) newWithUInt64:(uint64_t) value
{
   _MulleObjCUInt64Number  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}

- (int32_t) _int32Value     { return( (int32_t) _value); }
- (int64_t) _int64Value     { return( (int64_t)_value); }

- (BOOL) boolValue          { return( _value ? YES : NO); }
- (char) charValue          { return( (char) _value); }
- (short) shortValue        { return( (short) _value); }
- (int) intValue            { return( (int) _value); }
- (long) longValue          { return( (long) _value); }
- (NSInteger) integerValue  { return( (NSInteger) _value); }
- (long long) longLongValue { return( (long long) _value); }

- (unsigned char) unsignedCharValue   { return( (unsigned char) _value); }
- (unsigned short) unsignedShortValue { return( (unsigned short) _value); }
- (unsigned int) unsignedIntValue     { return( (unsigned int) _value); }
- (unsigned long) unsignedLongValue   { return( (unsigned long) _value); }
- (NSUInteger) unsignedIntegerValue   { return( (NSUInteger) _value); }
- (unsigned long long) unsignedLongLongValue { return( (unsigned long long) _value); }

- (double) doubleValue            { return( (double) _value); }
- (long double) longDoubleValue   { return( (long double) _value); }

- (void) getValue:(void *) value
{
   *(uint64_t *) value = _value;
}


- (mulle_objc_superquad) _superquadValue
{
   mulle_objc_superquad  value;
   
   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint64_t));
}

@end



@implementation _MulleObjCDoubleNumber : NSNumber

+ (id) newWithDouble:(double) value
{
   _MulleObjCDoubleNumber  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSUInteger) unsignedIntegerValue
{
   return( (NSUInteger) _value);
}


- (unsigned long long) unsignedLongLongValue
{
   return( (unsigned long long) _value);
}


- (double) doubleValue
{
   return( _value);
}


- (long double) longDoubleValue
{
   return( _value);
}


- (void) getValue:(void *) value
{
   *(double *) value = _value;
}


- (char *) objCType
{
   return( @encode( double));
}

@end


@implementation _MulleObjCLongDoubleNumber : NSNumber


+ (id) newWithLongDouble:(long double) value
{
   _MulleObjCLongDoubleNumber  *obj;
   
   obj = NSAllocateObject( self, 0, NULL);
   obj->_value = value;
   return( obj);
}


- (double) doubleValue
{
   return( (double) _value);
}


- (long double) longDoubleValue
{
   return( _value);
}


- (long long) longLongValue
{
   return( (long long) _value);
}


- (NSInteger) integerValue
{
   return( (NSInteger) _value);
}


- (void) getValue:(void *) value
{
   *(long double *) value = _value;
}


- (char *) objCType
{
   return( @encode( long double));
}

@end

