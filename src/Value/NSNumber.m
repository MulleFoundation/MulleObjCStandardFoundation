//
//  NSNumber.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSNumber.h"

// other files in this library
#import "_MulleObjCConcreteNumber.h"
#import "_MulleObjCTaggedPointerIntegerNumber.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCFoundationException.h"

// private stuff from MulleObjC
#import <MulleObjC/private/mulle-objc-exceptionhandlertable-private.h>
#import <MulleObjC/private/mulle-objc-universeconfiguration-private.h>

// std-c dependencies
#include <string.h>


@implementation NSObject( _NSNumber)

- (BOOL) __isNSNumber
{
   return( NO);
}

@end


@interface NSObject( Initialize)

+ (void) initialize;

@end


@implementation NSNumber

- (BOOL) __isNSNumber
{
   return( YES);
}


// here and not in +Classcluster for +initialize

enum _NSNumberClassClusterNumberType
{
   _NSNumberClassClusterInt8Type       = 0,
   _NSNumberClassClusterInt16Type      = 1,
   _NSNumberClassClusterInt32Type      = 2,
   _NSNumberClassClusterInt64Type      = 3,
   _NSNumberClassClusterUInt32Type     = 4,
   _NSNumberClassClusterUInt64Type     = 5,
   _NSNumberClassClusterDoubleType     = 6,
   _NSNumberClassClusterLongDoubleType = 7,
   _NSNumberClassClusterNumberTypeMax
};


#pragma mark - class cluster support

//
// it is useful for coverage, to make all possible subclasses known here
//
+ (void) initialize
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_infraclass_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   // don't do it again for subclasses
   if( config->numbersubclasses[ _NSNumberClassClusterInt8Type])
      return;

   [super initialize]; // get MulleObjCClassCluster initialize

   assert( _MULLE_OBJC_FOUNDATIONINFO_N_NUMBERSUBCLASSES >= _NSNumberClassClusterNumberTypeMax);

   config->numbersubclasses[ _NSNumberClassClusterInt8Type]       = [_MulleObjCInt8Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt16Type]      = [_MulleObjCInt16Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt32Type]      = [_MulleObjCInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt64Type]      = [_MulleObjCInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt32Type]     = [_MulleObjCUInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt64Type]     = [_MulleObjCUInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterDoubleType]     = [_MulleObjCDoubleNumber class];
   config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] = [_MulleObjCLongDoubleNumber class];
}


#define MULLE_C11_CONSUMED __attribute__((ns_consumed))


#pragma mark -
#pragma mark unsigned init

static inline id   initWithBOOL( NSNumber *self,
                                 BOOL value)
{
#ifdef __MULLE_OBJC_TPS__
   self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value ? YES : NO);
#else
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterInt8Type] newWithInt8:value ? YES : NO];
   }
#endif
   return( self);
}


static inline id   initWithUnsignedChar( NSNumber *self,
                                         unsigned char value)
{
#ifdef __MULLE_OBJC_TPS__
   self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
#else
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
   }
#endif
   return( self);
}


static inline id   initWithUnsignedShort( NSNumber *self, unsigned short value)
{
#ifdef __MULLE_OBJC_TPS__
   self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
#else
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
   }
#endif
   return( self);
}

static inline id   initWithUnsignedInt( NSNumber *self, unsigned int value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( unsigned int) == sizeof( uint32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];
   }
   return( self);
}


static inline id   initWithUnsignedInteger( NSNumber *self,
                                            NSUInteger value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( NSUInteger) == sizeof( uint32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];
   }
   return( self);
}


static inline id   initWithUnsignedLong( NSNumber *self, unsigned long value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( unsigned long) == sizeof( uint32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt32Type] newWithUInt32:value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];
   }
   return( self);
}


static inline id   initWithUnsignedLongLong( NSNumber *self,
                                             unsigned long long value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   assert( sizeof( unsigned long long) == sizeof( uint64_t));

   // does this really pay off, I doubt it
   if( value <= ULONG_MAX)
      return( initWithUnsignedLong( self, (unsigned long) value));

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];
   return( self);
}


#pragma mark - unsigned inits

- (instancetype) initWithBool:(BOOL) value
{
   return( initWithBOOL( self, value));
}


- (instancetype) initWithUnsignedChar:(unsigned char) value
{
   return( initWithUnsignedChar( self, value));
}


- (instancetype) initWithUnsignedShort:(unsigned short) value
{
   return( initWithUnsignedShort( self, value));
}


- (instancetype) initWithUnsignedInt:(unsigned int) value
{
   return( initWithUnsignedInt( self, value));
}


- (instancetype) initWithUnsignedLong:(unsigned long) value
{
   return( initWithUnsignedLong( self, value));
}


- (instancetype) initWithUnsignedInteger:(NSUInteger) value
{
   return( initWithUnsignedInteger( self, value));
}


- (instancetype) initWithUnsignedLongLong:(unsigned long long) value
{
   return( initWithUnsignedLongLong( self, value));
}


#pragma mark - signed inits

static inline id   initWithChar( NSNumber *self, char value)
{
   assert( sizeof( char) == sizeof( int8_t));

#ifdef __MULLE_OBJC_TPS__
   self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
#else
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterInt8Type] newWithInt8:value];
   }
#endif
   return( self);
}


#ifdef _C_BOOL
static inline id   initWithBool( NSNumber *self, _Bool value)
{
   return( initWithChar( self, (char) value));
}
#endif


static inline id   initWithShort( NSNumber *self, short value)
{
#ifdef __MULLE_OBJC_TPS__
   self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
#else
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      self = [config->numbersubclasses[ _NSNumberClassClusterInt16Type] newWithInt16:value];
   }
#endif
   return( self);
}


static inline id   initWithInt( NSNumber *self, int value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue(value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( int) == sizeof( int32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterInt32Type] newWithInt32:value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   }

   return( self);
}


static inline id   initWithInteger( NSNumber *self,
                                    NSInteger value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue(value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe    *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( NSInteger) == sizeof( int32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterInt32Type] newWithInt32:(int32_t)value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   }
   return( self);
}


static inline id   initWithLong( NSNumber *self,
                                 long value)
{
#ifdef __MULLE_OBJC_TPS__
   if( MulleObjCTaggedPointerIsIntegerValue( value))
   {
      self = _MulleObjCTaggedPointerIntegerNumberWithInteger( value);
   }
   else
#endif
   {
      struct _mulle_objc_universefoundationinfo   *config;
      struct _mulle_objc_universe                 *universe;

      universe = _mulle_objc_object_get_universe( self);
      _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

      if( sizeof( long) == sizeof( int32_t))
         self = [config->numbersubclasses[ _NSNumberClassClusterInt32Type] newWithInt32:value];
      else
         self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   }
   return( self);
}


static inline id   initWithLongLong( NSNumber *self,
                                     long long  value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   assert( sizeof( long long) == sizeof( int64_t));

   if( value <= LONG_MAX && value >= LONG_MIN)
      return( initWithLong( self, (long) value));

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   return( self);
}


- (instancetype) initWithChar:(char) value
{
   return( initWithChar( self, value));
}


- (instancetype) initWithShort:(short) value
{
   return( initWithShort( self, value));
}


- (instancetype) initWithInt:(int) value
{
   return( initWithInt( self, value));
}


- (instancetype) initWithLong:(long) value
{
   return( initWithLong( self, value));
}


- (instancetype) initWithInteger:(NSInteger) value
{
   return( initWithInteger( self, value));
}


- (instancetype) initWithLongLong:(long long) value
{
   return( initWithLongLong( self, value));
}


#pragma mark -
#pragma marl FP inits


- (instancetype) initWithFloat:(float) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterDoubleType] newWithDouble:value];
   return( self);
}


- (instancetype) initWithDouble:(double) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterDoubleType] newWithDouble:value];
   return( self);
}


- (instancetype) initWithLongDouble:(long double) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe    *universe;

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   self = [config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] newWithLongDouble:value];
   return( self);
}


#pragma mark -
#pragma mark NSValue init


- (instancetype) initWithBytes:(void *) value
                      objCType:(char *) type
{
   if( ! value)
      MulleObjCThrowInvalidArgumentException( @"empty bytes");
   if( ! type)
      MulleObjCThrowInvalidArgumentException( @"empty type");

   switch( type[ 0])
   {
#ifdef _C_BOOL
   case _C_BOOL     : return( initWithBool( self, *(_Bool *) value));
#endif
   case _C_CHR      : return( initWithChar( self, *(char *) value));
   case _C_UCHR     : return( initWithUnsignedChar( self, *(unsigned char *) value));
   case _C_SHT      : return( initWithShort( self, *(short *) value));
   case _C_USHT     : return( initWithUnsignedShort( self, *(unsigned short *) value));
   case _C_INT      : return( initWithInt( self, *(int *) value));
   case _C_UINT     : return( initWithUnsignedInt( self, *(unsigned int *) value));
   case _C_LNG      : return( initWithLong( self, *(long *) value));
   case _C_ULNG     : return( initWithUnsignedLong( self, *(unsigned long *) value));
   case _C_LNG_LNG  : return( initWithLongLong( self, *(long long *) value));
   case _C_ULNG_LNG : return( initWithUnsignedLongLong( self, *(unsigned long long *) value));

   case _C_FLT      : return( [self initWithFloat:*(float *) value]);
   case _C_DBL      : return( [self initWithDouble:*(double *) value]);
   case _C_LNG_DBL  : return( [self initWithLongDouble:*(double *) value]);
   default          : MulleObjCThrowInvalidArgumentException( @"unknown type '%c'", type[ 0]);
   }
}


#pragma mark - convenience constructors

// don't short-circuit for subclasses

+ (instancetype) numberWithBool:(BOOL) value
{
   return( [[[self alloc] initWithBool:value] autorelease]);
}


+ (instancetype) numberWithChar:(char) value
{
   return( [[[self alloc] initWithChar:value] autorelease]);
}


+ (instancetype) numberWithUnsignedChar:(unsigned char) value
{
   return( [[[self alloc] initWithUnsignedChar:value] autorelease]);
}


+ (instancetype) numberWithShort:(short) value
{
   return( [[[self alloc] initWithShort:value] autorelease]);
}


+ (instancetype) numberWithUnsignedShort:(unsigned short) value
{
   return( [[[self alloc] initWithUnsignedShort:value] autorelease]);
}


+ (instancetype) numberWithInt:(int) value
{
   return( [[[self alloc] initWithInt:value] autorelease]);
}


+ (instancetype) numberWithUnsignedInt:(unsigned int) value;
{
   return( [[[self alloc] initWithUnsignedInt:value] autorelease]);
}


+ (instancetype) numberWithLong:(long) value
{
   return( [[[self alloc] initWithLong:value] autorelease]);
}


+ (instancetype) numberWithUnsignedLong:(unsigned long) value
{
   return( [[[self alloc] initWithUnsignedLong:value] autorelease]);
}


+ (instancetype) numberWithInteger:(NSInteger) value
{
   return( [[[self alloc] initWithInteger:value] autorelease]);
}


+ (instancetype) numberWithUnsignedInteger:(NSUInteger) value
{
   return( [[[self alloc] initWithUnsignedInteger:value] autorelease]);
}


+ (instancetype) numberWithLongLong:(long long) value
{
   return( [[[self alloc] initWithLongLong:value] autorelease]);
}


+ (instancetype) numberWithUnsignedLongLong:(unsigned long long) value
{
   return( [[[self alloc] initWithUnsignedLongLong:value] autorelease]);
}


+ (instancetype) numberWithFloat:(float) value
{
   return( [[[self alloc] initWithFloat:value] autorelease]);
}


+ (instancetype) numberWithDouble:(double) value
{
   return( [[[self alloc] initWithDouble:value] autorelease]);
}


+ (instancetype) numberWithLongDouble:(long double) value
{
   return( [[[self alloc] initWithLongDouble:value] autorelease]);
}


#pragma mark -
#pragma mark operations

/*
 * this compare: "properly" promotes all comparisons to unsigned
 * if one ot the two numbers is unsigned (and not FP)
 * this is I believe different from Apple
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
#ifdef _C_BOOL
   case _C_BOOL :
#endif
   case _C_CHR  :
   case _C_SHT  :
   case _C_INT  :
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
- (_ns_superquad) _superquadValue
{
   _ns_superquad  value;
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
   _ns_superquad          a128, b128;
   double                 da, db;
   long double            lda, ldb;
   int                    type;
   int                    other_type;

   // apple dox says: must be a number, can't be nil

   NSCParameterAssert( [other __isNSNumber]);

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
   return( _ns_superquad_compare( a128, b128));

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
}


#pragma mark - hash and equality

// NSNumbers are NSValues so don't do isEqual: or hash

- (BOOL) isEqualToNumber:(NSNumber *) other
{
   if( self == other)
      return( YES);
   return( [other compare:self] == NSOrderedSame);
}


- (id) copy
{
   return( [self retain]);
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


// a default for the placeholder (debugging help)
- (char *) objCType
{
   return( @encode( void));
}


@end
