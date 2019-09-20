//
//  _MulleObjCConcreteNumber.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

#import "_MulleObjCConcreteNumber.h"

// other files in this library

// other libraries of MulleObjCStandardFoundation

// std-c and dependencies


@implementation _MulleObjCInt8Number : NSNumber

+ (instancetype) newWithInt8:(int8_t) value
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

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end


@implementation _MulleObjCInt16Number : NSNumber

+ (instancetype) newWithInt16:(int16_t) value
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

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end



@implementation _MulleObjCInt32Number : NSNumber

+ (instancetype) newWithInt32:(int32_t) value
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

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end



@implementation _MulleObjCInt64Number

+ (instancetype) newWithInt64:(int64_t) value
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
   *(long long *) value = _value;
}


- (char *) objCType
{
   return( @encode( int64_t));
}

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end


@implementation _MulleObjCUInt32Number : NSNumber

+ (instancetype) newWithUInt32:(uint32_t) value
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


- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;

   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint32_t));
}

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end


@implementation _MulleObjCUInt64Number : NSNumber

+ (instancetype) newWithUInt64:(uint64_t) value
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


- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;

   value.lo = _value;
   value.hi = 0;
   return( value);
}


- (char *) objCType
{
   return( @encode( uint64_t));
}

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end



@implementation _MulleObjCDoubleNumber : NSNumber

+ (instancetype) newWithDouble:(double) value
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

- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}

@end


@implementation _MulleObjCLongDoubleNumber : NSNumber


+ (instancetype) newWithLongDouble:(long double) value
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


- (NSUInteger) hash
{
   return( MulleObjCBytesHash( &_value, sizeof( _value)));
}


@end
