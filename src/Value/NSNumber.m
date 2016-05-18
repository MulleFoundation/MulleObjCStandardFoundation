/*
 *  NSTinyFoundation - A tiny Foundation replacement
 *
 *  NSNumber.m is a part of NSTinyFoundation
 *
 *  Copyright (C) 2011 Nat!, NS kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNumber.h"

// other files in this library
#import "_MulleObjCConcreteNumber.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationException.h"

// std-c dependencies
#include <string.h>


@implementation NSObject( _NSNumber)

- (BOOL) __isNSNumber
{
   return( NO);
}

@end


@implementation NSNumber

- (BOOL) __isNSNumber
{
   return( YES);
}


- (id) initWithBytes:(void *) value
            objCType:(char *) type
{
   long       l;
   long long  q;
   double     d;
   size_t     size;
   int        is_unsigned;
   
   is_unsigned = 0;
   switch( type[ 0])
   {
   case _C_CHR      : l = *(char *) value;           size = sizeof( char); break;
   case _C_UCHR     : l = *(unsigned char *) value;  size = sizeof( unsigned char); is_unsigned = 1; break;
   case _C_SHT      : l = *(short *) value;          size = sizeof( short); break;
   case _C_USHT     : l = *(unsigned short *) value; size = sizeof( unsigned short); is_unsigned = 1; break;
   case _C_INT      : l = *(int *) value;            size = sizeof( int); break;
   case _C_UINT     : l = *(unsigned int *) value;   size = sizeof( unsigned int); is_unsigned = 1; break;
   case _C_LNG      : l = *(long *) value;           size = sizeof( long); break;
   case _C_ULNG     : l = *(unsigned long *) value;  size = sizeof( unsigned long); is_unsigned = 1;  break;
   case _C_LNG_LNG  : q = *(long long *) value;      size = sizeof( long long); break;
   case _C_ULNG_LNG : q = *(unsigned long long *) value; size = sizeof( unsigned long long); is_unsigned = 1; break;
         
   case _C_FLT      : d = *(float *) value;          return( [self initWithDouble:d]);
   case _C_DBL      : d = *(double *) value;         return( [self initWithDouble:d]);
   default          : return( nil);
   }

   [self release];
   if( size == sizeof( int8_t))
   {
      if( is_unsigned)
         return( [_MulleObjCUInt32Number newWithUInt32:(uint32_t) l]);
      return( [_MulleObjCInt8Number newWithInt8:(int8_t) l]);
   }

   if( size == sizeof( int16_t))
   {
      if( is_unsigned)
         return( [_MulleObjCUInt32Number newWithUInt32:(uint32_t) l]);
      return( [_MulleObjCInt16Number newWithInt16:(int16_t) l]);
   }

   if( size == sizeof( int32_t))
   {
      if( is_unsigned)
         return( [_MulleObjCUInt32Number newWithUInt32:(uint32_t) l]);
      return( [_MulleObjCInt32Number newWithInt32:(int32_t) l]);
   }
   assert( sizeof( long long) <= sizeof( int64_t));
   if( is_unsigned)
      return( [_MulleObjCUInt64Number newWithUInt64:(uint64_t) q]);
   return( [_MulleObjCInt64Number newWithInt64:(int64_t) q]);
}


- (id) initWithBool:(BOOL) value
{
   [self release];

   return( [_MulleObjCInt8Number newWithInt8:value ? YES : NO]);
}


- (id) initWithChar:(char) value
{
   [self release];
   
   assert( sizeof( char) == sizeof( int8_t));
   return( [_MulleObjCInt8Number newWithInt8:value]);
}


- (id) initWithUnsignedChar:(unsigned char) value
{
   [self release];
   
   return( [_MulleObjCUInt32Number newWithUInt32:value]);
}


- (id) initWithShort:(short) value
{
   [self release];
   
   assert( sizeof( short) == sizeof( int16_t));
   return( [_MulleObjCInt16Number newWithInt16:value]);
}


- (id) initWithUnsignedShort:(unsigned short) value
{
   [self release];
   
   return( [_MulleObjCUInt32Number newWithUInt32:value]);
}


- (id) initWithInt:(int) value
{
   [self release];
   
   if( sizeof( int) == sizeof( int32_t))
      return( [_MulleObjCInt32Number newWithInt32:value]);
   else
      return( [_MulleObjCInt64Number newWithInt64:value]);
}


- (id) initWithUnsignedInt:(unsigned int) value
{
   [self release];
   
   if( sizeof( unsigned int) == sizeof( uint32_t))
      return( [_MulleObjCUInt32Number newWithUInt32:value]);
   else
      return( [_MulleObjCUInt64Number newWithUInt64:value]);
}


- (id) initWithLong:(long) value
{
   [self release];
   
   if( sizeof( long) == sizeof( int32_t))
      return( [_MulleObjCInt32Number newWithInt32:value]);
   else
      return( [_MulleObjCInt64Number newWithInt64:value]);
}


- (id) initWithUnsignedLong:(unsigned long) value
{
   [self release];

   if( sizeof( unsigned long) == sizeof( uint32_t))
      return( [_MulleObjCUInt32Number newWithUInt32:value]);
   else
      return( [_MulleObjCUInt64Number newWithUInt64:value]);
}


- (id) initWithInteger:(NSInteger) value
{
   [self release];
   
   if( sizeof( NSInteger) == sizeof( int32_t))
      return( [_MulleObjCInt32Number newWithInt32:value]);
   else
      return( [_MulleObjCInt64Number newWithInt64:value]);
}


- (id) initWithUnsignedInteger:(NSUInteger) value
{
   [self release];
   
   if( sizeof( NSUInteger) == sizeof( uint32_t))
      return( [_MulleObjCUInt32Number newWithUInt32:value]);
   else
      return( [_MulleObjCUInt64Number newWithUInt64:value]);
}


- (id) initWithLongLong:(long long) value
{
   assert( sizeof( long long) == sizeof( int64_t));

   [self release];
   return( [_MulleObjCInt64Number newWithInt64:value]);
}


- (id) initWithUnsignedLongLong:(unsigned long long) value
{
   assert( sizeof( unsigned long long) == sizeof( uint64_t));

   [self release];
   return( [_MulleObjCUInt64Number newWithUInt64:value]);
}


- (id) initWithFloat:(float) value
{
   [self release];
   
   return( [_MulleObjCDoubleNumber newWithDouble:value]);
}


- (id) initWithDouble:(double) value
{
   [self release];
   
   return( [_MulleObjCDoubleNumber newWithDouble:value]);
}


- (id) initWithLongDouble:(long double) value
{
   [self release];
   
   return( [_MulleObjCLongDoubleNumber newWithLongDouble:value]);
}


#pragma mark -
#pragma mark convenience constructors 

// don't short-circuit for subclasses

+ (id) numberWithBool:(BOOL) value
{
   return( [[[self alloc] initWithBool:value] autorelease]);
}


+ (id) numberWithChar:(char) value
{
   return( [[[self alloc] initWithChar:value] autorelease]);
}


+ (id) numberWithUnsignedChar:(unsigned char) value
{
   return( [[[self alloc] initWithUnsignedChar:value] autorelease]);
}


+ (id) numberWithShort:(short) value
{
   return( [[[self alloc] initWithShort:value] autorelease]);
}


+ (id) numberWithUnsignedShort:(unsigned short) value
{
   return( [[[self alloc] initWithUnsignedShort:value] autorelease]);
}


+ (id) numberWithInt:(int) value
{
   return( [[[self alloc] initWithInt:value] autorelease]);
}


+ (id) numberWithUnsignedInt:(unsigned int) value;
{
   return( [[[self alloc] initWithUnsignedInt:value] autorelease]);
}


+ (id) numberWithLong:(long) value
{
   return( [[[self alloc] initWithLong:value] autorelease]);
}


+ (id) numberWithUnsignedLong:(unsigned long) value
{
   return( [[[self alloc] initWithUnsignedLong:value] autorelease]);
}


+ (id) numberWithInteger:(NSInteger) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (id) numberWithUnsignedInteger:(NSUInteger) value
{
   return( [[[self alloc] initWithUnsignedInteger:value] autorelease]);
}


+ (id) numberWithLongLong:(long long) value
{
   return( [[[self alloc] initWithLongLong:value] autorelease]);
}


+ (id) numberWithUnsignedLongLong:(unsigned long long) value
{
   return( [[[self alloc] initWithUnsignedLongLong:value] autorelease]);
}


+ (id) numberWithFloat:(float) value
{
   return( [[[self alloc] initWithFloat:value] autorelease]);
}


+ (id) numberWithDouble:(double) value
{
   return( [[[self alloc] initWithDouble:value] autorelease]);
}


+ (id) numberWithLongDouble:(long double) value
{
   return( [[[self alloc] initWithLongDouble:value] autorelease]);
}


#pragma mark -
#pragma mark operations

/*
 * this compare: "properly" promotes all comparisons to unsigned
 * if one ot the two numbers is unsigned (and not FP)
 * this is is believe different from Apple 
 */
#define _C_SUPERQUAD  1848

// returns
//  _C_INT          // 32 bit
//  _C_LNG_LNG      // 64 bit
//  _C_SUPERQUAD    // 128 bit
//  _C_DBL          // double
//  _C_LNG_DBL      // double

static int  simplify_type_for_comparison( int type)
{
   switch( type)
   {
   case _C_CHR :
   case _C_SHT :
   case _C_INT :
   case _C_UCHR :
   case _C_USHT :
      return( _C_INT);
         
   case _C_UINT :
       if( sizeof( unsigned int) == sizeof( int32_t))
          return( _C_LNG_LNG);
       return( _C_SUPERQUAD);

   case _C_LNG :
      if( sizeof( long) == sizeof( int32_t))
         return( _C_INT);
      return( _C_LNG_LNG);
         
   case _C_ULNG :
      if( sizeof( unsigned long) == sizeof( int32_t))
         return( _C_LNG_LNG);
      return( _C_SUPERQUAD);

   case _C_LNG_LNG :
       return( _C_LNG_LNG);
         
   case _C_ULNG_LNG :
      return( _C_SUPERQUAD);
         
   case _C_FLT     :
      return( _C_DBL);
   }
   return( type);
}


//
// generic routines for all
//
- (mulle_objc_superquad) _superquadValue
{
   mulle_objc_superquad  value;
   long long             x;
   
   x        = [self longLongValue];
   value.lo = x;
   value.hi = (x < 0) ? ~0 : 0;
   return( value);
}


- (int32_t) _int32Value
{
   return( (int32_t) [self integerValue]);
}


- (int64_t) _int64Value
{
   return( (int64_t) [self longLongValue]);
}


- (NSComparisonResult) compare:(NSNumber *) other
{
   char                   *p_type;
   char                   *p_other_type;
   int32_t                a32, b32;
   int64_t                a64, b64;
   mulle_objc_superquad   a128, b128;
   double                 da, db;
   long double            lda, ldb;
   int                    type;
   int                    other_type;
   
   p_type       = [self objCType];
   p_other_type = other ? [other objCType] : @encode( int);
   
   NSCParameterAssert( p_type && strlen( p_type) == 1);
   NSCParameterAssert( p_other_type && strlen( p_other_type) == 1);
   
   type       = simplify_type_for_comparison( *p_type);
   other_type = simplify_type_for_comparison( *p_other_type);
   
   switch( type)
   {
   default  : goto bail;
   case _C_INT :
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       : goto do_32_32_diff;
      case _C_LNG_LNG   : goto do_64_64_diff;
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }
         
   case _C_LNG_LNG : 
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       :
      case _C_LNG_LNG   : goto do_64_64_diff;
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }
         
         
   case _C_SUPERQUAD :
      switch( other_type)
      {
      default           : goto bail;
      case _C_INT       :
      case _C_LNG_LNG   :
      case _C_SUPERQUAD : goto do_128_128_diff;
      case _C_DBL       : goto do_d_d_diff;
      case _C_LNG_DBL   : goto do_ld_ld_diff;
      }
         
   case _C_DBL          : goto do_d_d_diff;
   case _C_LNG_DBL      : goto do_ld_ld_diff;
   }
   
   // TODO: check for unsigned comparison
   // hint: don't do subtraction
do_32_32_diff:
   a32 = [self _int32Value];
   b32 = [other _int32Value];
   if( a32 == b32)
      return( NSOrderedSame);
   return( a32 < b32 ? NSOrderedAscending : NSOrderedDescending);

do_64_64_diff :
   a64 = [self _int64Value];
   b64 = [other _int64Value];
   if( a64 == b64)
      return( NSOrderedSame);
   return( a64 < b64 ? NSOrderedAscending : NSOrderedDescending);

do_128_128_diff :
   a128 = [self _superquadValue];
   b128 = [other _superquadValue];
   return( mulle_objc_superquad_compare( a128, b128));
   
do_d_d_diff :
   da = [self doubleValue];
   db = [other doubleValue];
   if( da == db)
      return( NSOrderedSame);
   return( da < db ? NSOrderedAscending : NSOrderedDescending);
   
do_ld_ld_diff :
   lda = [self longDoubleValue];
   ldb = [other longDoubleValue];
   if( lda == ldb)
      return( NSOrderedSame);
   return( lda < ldb ? NSOrderedAscending : NSOrderedDescending);
   
bail:
   MulleObjCThrowInternalInconsistencyException( @"unknown objctype");
   return( 0);
}


- (NSUInteger) hash
{
   NSUInteger  value;
   uintptr_t   hash;
   
   value = [self unsignedIntegerValue];
   hash  = mulle_hash( &value, sizeof( NSUInteger)); // stay compatible to NSValue
   
   return( hash);
}


- (BOOL) isEqualToNumber:(NSNumber *) other
{
   if( self == other)
      return( YES);
   return( [other compare:self] == NSOrderedSame);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSNumber])
      return( NO);
   return( [self isEqualToNumber:other]);
}


- (id) copy
{
   return( [self retain]);
}


#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSNumber class]);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}


#pragma mark -
#pragma mark value conversion from primitives

- (BOOL) boolValue
{
   return( [self integerValue] ? YES : NO);
}


- (char) charValue
{
   return( (char) [self integerValue]);
}


- (unsigned char) unsignedCharValue
{
   return( (unsigned char) [self integerValue]);
}


- (short) shortValue
{
   return( (short) [self integerValue]);
}


- (unsigned short) unsignedShortValue
{
   return( (unsigned short) [self integerValue]);
}


- (int) intValue
{
   return( (int) [self integerValue]);
}


- (unsigned int) unsignedIntValue
{
   return( (unsigned int) [self integerValue]);
}


- (long) longValue
{
   assert( sizeof( NSInteger) >= sizeof( long));
   return( (long) [self integerValue]);
}


- (unsigned long) unsignedLongValue
{
   assert( sizeof( NSInteger) >= sizeof( unsigned long));
   return( (unsigned long) [self integerValue]);
}


- (NSUInteger) unsignedIntegerValue
{
   return( (NSUInteger) [self integerValue]);
}


- (float) floatValue
{
   return( (float) [self doubleValue]);
}


- (unsigned long long) unsignedLongLongValue
{
   return( (unsigned long long) [self longLongValue]);
}


@end
