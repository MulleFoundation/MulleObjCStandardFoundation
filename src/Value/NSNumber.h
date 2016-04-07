/*
 *  NSTinyFoundation - A tiny Foundation replacement
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

@end


@interface NSNumber ( Subclasses)

- (NSInteger) integerValue;
- (double) doubleValue;
- (long long) longLongValue;

@end


