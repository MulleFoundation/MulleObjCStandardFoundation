/*
 *  NSTinyFoundation - the mulle-objc class library
 *
 *  NSNumber.h is a part of NSTinyFoundation
 *
 *  Copyright (C) 2011 Nat!, NS kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSValue.h"


typedef struct
{
#ifdef __LITTLE_ENDIAN__
   uint64_t   lo;
   int64_t    hi;
#else
   int64_t    hi;
   uint64_t   lo;
#endif
} mulle_objc_superquad;


static inline int   mulle_objc_superquad_compare( mulle_objc_superquad a, mulle_objc_superquad b)
{
   if( a.hi != b.hi)
      return( a.hi < b.hi ? NSOrderedAscending : NSOrderedDescending);

   if( a.lo == b.lo)
      return( NSOrderedSame);

    return( a.lo < b.lo ? NSOrderedAscending : NSOrderedDescending);
}


@interface NSNumber : NSValue < NSCopying, MulleObjCClassCluster>
{
}


+ (id) numberWithChar:(char) value;
+ (id) numberWithUnsignedChar:(unsigned char) value;
+ (id) numberWithShort:(short) value;
+ (id) numberWithUnsignedShort:(unsigned short) value;
+ (id) numberWithInt:(int) value;
+ (id) numberWithUnsignedInt:(unsigned int) value;
+ (id) numberWithInteger:(NSInteger) value;
+ (id) numberWithUnsignedInteger:(NSUInteger) value;
+ (id) numberWithLong:(long) value;
+ (id) numberWithUnsignedLong:(unsigned long) value;
+ (id) numberWithLongLong:(long long) value;
+ (id) numberWithUnsignedLongLong:(unsigned long long) value;
+ (id) numberWithFloat:(float) value;
+ (id) numberWithDouble:(double) value;
+ (id) numberWithLongDouble:(long double) value;
+ (id) numberWithBool:(BOOL) value;

- (NSComparisonResult) compare:(id) other;
- (BOOL) isEqualToNumber:(id) other;
- (BOOL) isEqual:(id) other;
- (NSUInteger) hash;

- (id) initWithChar:(char) value;
- (id) initWithUnsignedChar:(unsigned char) value;
- (id) initWithShort:(short) value;
- (id) initWithUnsignedShort:(unsigned short) value;
- (id) initWithInt:(int) value;
- (id) initWithUnsignedInt:(unsigned int) value;
- (id) initWithInteger:(NSInteger) value;
- (id) initWithUnsignedInteger:(NSUInteger) value;
- (id) initWithLong:(long) value;
- (id) initWithUnsignedLong:(unsigned long) value;
- (id) initWithLongLong:(long long) value;
- (id) initWithUnsignedLongLong:(unsigned long long) value;
- (id) initWithFloat:(float) value;
- (id) initWithDouble:(double) value;
- (id) initWithLongDouble:(long double) value;
- (id) initWithBool:(BOOL) value;

- (BOOL) boolValue;
- (NSUInteger) unsignedIntegerValue;
- (char) charValue;
- (unsigned char) unsignedCharValue;
- (short) shortValue;
- (unsigned short) unsignedShortValue;
- (int) intValue;
- (unsigned int) unsignedIntValue;
- (long) longValue;
- (unsigned long) unsignedLongValue;
- (float) floatValue;
- (unsigned long long) unsignedLongLongValue;


// need this for comparison until I get smarter
- (mulle_objc_superquad) _superquadValue;

@end


@interface NSNumber ( Subclasses)

- (NSInteger) integerValue;
- (double) doubleValue;
- (long double) longDoubleValue;
- (long long) longLongValue;

@end


