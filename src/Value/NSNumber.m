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

   if( self != [NSNumber class])
      return;

   [super initialize]; // get MulleObjCClassCluster initialize

   assert( _MULLE_OBJC_FOUNDATIONINFO_N_NUMBERSUBCLASSES >= _NSNumberClassClusterNumberTypeMax);

   universe = _mulle_objc_infraclass_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   config->numbersubclasses[ _NSNumberClassClusterInt8Type]   = [_MulleObjCInt8Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt16Type]  = [_MulleObjCInt16Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt32Type]  = [_MulleObjCInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterInt64Type]  = [_MulleObjCInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt32Type] = [_MulleObjCUInt32Number class];
   config->numbersubclasses[ _NSNumberClassClusterUInt64Type] = [_MulleObjCUInt64Number class];
   config->numbersubclasses[ _NSNumberClassClusterDoubleType] = [_MulleObjCDoubleNumber class];
   config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] = [_MulleObjCLongDoubleNumber class];
}


#define MULLE_C11_CONSUMED __attribute__((ns_consumed))


#pragma mark -
#pragma mark unsigned init

static inline id   replacePlaceholderWithBOOL( MULLE_C11_CONSUMED NSNumber *self,
                                                  BOOL value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithUnsignedChar( MULLE_C11_CONSUMED NSNumber *self,
                                                          unsigned char value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithUnsignedShort( MULLE_C11_CONSUMED NSNumber *self, unsigned short value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}

static inline id   replacePlaceholderWithUnsignedInt( MULLE_C11_CONSUMED NSNumber *self, unsigned int value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithUnsignedInteger( MULLE_C11_CONSUMED NSNumber *self,
                                                             NSUInteger value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithUnsignedLong( MULLE_C11_CONSUMED NSNumber *self, unsigned long value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithUnsignedLongLong( MULLE_C11_CONSUMED NSNumber *self,
                                                           unsigned long long value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   id                                          old;

   assert( sizeof( unsigned long long) == sizeof( uint64_t));

   // does this really pay off, I doubt it
   if( value <= ULONG_MAX)
      return( replacePlaceholderWithUnsignedLong( self, (unsigned long) value));

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   old  = self;
   self = [config->numbersubclasses[ _NSNumberClassClusterUInt64Type] newWithUInt64:value];

   [old release];
   return( self);
}


#pragma mark - unsigned inits

- (instancetype) initWithBool:(BOOL) value
{
   return( replacePlaceholderWithBOOL( self, value));
}


- (instancetype) initWithUnsignedChar:(unsigned char) value
{
   return( replacePlaceholderWithUnsignedChar( self, value));
}


- (instancetype) initWithUnsignedShort:(unsigned short) value
{
   return( replacePlaceholderWithUnsignedShort( self, value));
}


- (instancetype) initWithUnsignedInt:(unsigned int) value
{
   return( replacePlaceholderWithUnsignedInt( self, value));
}


- (instancetype) initWithUnsignedLong:(unsigned long) value
{
   return( replacePlaceholderWithUnsignedLong( self, value));
}


- (instancetype) initWithUnsignedInteger:(NSUInteger) value
{
   return( replacePlaceholderWithUnsignedInteger( self, value));
}


- (instancetype) initWithUnsignedLongLong:(unsigned long long) value
{
   return( replacePlaceholderWithUnsignedLongLong( self, value));
}


#pragma mark - signed inits

static inline id   replacePlaceholderWithChar( MULLE_C11_CONSUMED NSNumber *self, char value)
{
   id   old;

   assert( sizeof( char) == sizeof( int8_t));

   old = self;
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
   [old release];
   return( self);
}


#ifdef _C_BOOL
static inline id   replacePlaceholderWithBool( MULLE_C11_CONSUMED NSNumber *self, _Bool value)
{
   return( replacePlaceholderWithChar( self, (char) value));
}
#endif


static inline id   replacePlaceholderWithShort( MULLE_C11_CONSUMED NSNumber *self, short value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithInt( MULLE_C11_CONSUMED NSNumber *self, int value)
{
   id   old;

   old = self;
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

   [old release];
   return( self);
}


static inline id   replacePlaceholderWithInteger( MULLE_C11_CONSUMED NSNumber *self,
                                                     NSInteger value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithLong( MULLE_C11_CONSUMED NSNumber *self,
                                               long value)
{
   id   old;

   old = self;
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
   [old release];
   return( self);
}


static inline id   replacePlaceholderWithLongLong( MULLE_C11_CONSUMED NSNumber *self,
                                                            long long  value)
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   id                                          old;

   assert( sizeof( long long) == sizeof( int64_t));

   if( value <= LONG_MAX && value >= LONG_MIN)
      return( replacePlaceholderWithLong( self, (long) value));

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   old  = self;
   self = [config->numbersubclasses[ _NSNumberClassClusterInt64Type] newWithInt64:value];
   [old release];
   return( self);
}


- (instancetype) initWithChar:(char) value
{
   return( replacePlaceholderWithChar( self, value));
}


- (instancetype) initWithShort:(short) value
{
   return( replacePlaceholderWithShort( self, value));
}


- (instancetype) initWithInt:(int) value
{
   return( replacePlaceholderWithInt( self, value));
}


- (instancetype) initWithLong:(long) value
{
   return( replacePlaceholderWithLong( self, value));
}


- (instancetype) initWithInteger:(NSInteger) value
{
   return( replacePlaceholderWithInteger( self, value));
}


- (instancetype) initWithLongLong:(long long) value
{
   return( replacePlaceholderWithLongLong( self, value));
}


#pragma mark -
#pragma marl FP inits


- (instancetype) initWithFloat:(float) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   id                                          old;

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   old  = self;
   self = [config->numbersubclasses[ _NSNumberClassClusterDoubleType] newWithDouble:value];
   [old release];
   return( self);
}


- (instancetype) initWithDouble:(double) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe                 *universe;
   id                                          old;

   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   old  = self;
   self = [config->numbersubclasses[ _NSNumberClassClusterDoubleType] newWithDouble:value];
   [old release];
   return( self);
}


- (instancetype) initWithLongDouble:(long double) value
{
   struct _mulle_objc_universefoundationinfo   *config;
   struct _mulle_objc_universe    *universe;
   id   old;


   universe = _mulle_objc_object_get_universe( self);
   _mulle_objc_universe_get_foundationspace( universe, (void **) &config, NULL);

   old  = self;
   self = [config->numbersubclasses[ _NSNumberClassClusterLongDoubleType] newWithLongDouble:value];
   [old release];
   return( self);
}


#pragma mark -
#pragma mark NSValue init


- (instancetype) initWithBytes:(void *) value
                      objCType:(char *) type
{
   switch( type[ 0])
   {
#ifdef _C_BOOL
   case _C_BOOL     : return( replacePlaceholderWithBool( self, *(_Bool *) value));
#endif
   case _C_CHR      : return( replacePlaceholderWithChar( self, *(char *) value));
   case _C_UCHR     : return( replacePlaceholderWithUnsignedChar( self, *(unsigned char *) value));
   case _C_SHT      : return( replacePlaceholderWithShort( self, *(short *) value));
   case _C_USHT     : return( replacePlaceholderWithUnsignedShort( self, *(unsigned short *) value));
   case _C_INT      : return( replacePlaceholderWithInt( self, *(int *) value));
   case _C_UINT     : return( replacePlaceholderWithUnsignedInt( self, *(unsigned int *) value));
   case _C_LNG      : return( replacePlaceholderWithLong( self, *(long *) value));
   case _C_ULNG     : return( replacePlaceholderWithUnsignedLong( self, *(unsigned long *) value));
   case _C_LNG_LNG  : return( replacePlaceholderWithLongLong( self, *(long long *) value));
   case _C_ULNG_LNG : return( replacePlaceholderWithUnsignedLongLong( self, *(unsigned long long *) value));

   case _C_FLT      : return( [self initWithFloat:*(float *) value]);
   case _C_DBL      : return( [self initWithDouble:*(double *) value]);
   case _C_LNG_DBL  : return( [self initWithLongDouble:*(double *) value]);
   default          : return( nil);
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
