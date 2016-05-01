/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNumberFormatter.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSFormatter.h"


@class NSNumber;
@class NSString;


enum 
{
    NSNumberFormatterBehaviorDefault = 0,
    NSNumberFormatterBehavior10_0    = 1000,
    NSNumberFormatterBehavior10_4    = 1040  // defined but do not have
};
typedef NSUInteger NSNumberFormatterBehavior;


@interface NSNumberFormatter : NSFormatter 
{
   id         _roundingBehavior;
   id         _locale;
   
   struct
   {
      unsigned    allowsFloats:1;
      unsigned    generatesDecimalNumbers:1;
      unsigned    hasThousandSeparators:1;
      unsigned    localizesFormat:1;
      unsigned    unused:12;
   } _flags;
}

@property( assign) NSNumberFormatterBehavior  formatterBehavior;

@property( copy) NSString     *format;
@property( copy) NSString     *negativeFormat;
@property( copy) NSString     *positiveFormat;
@property( copy) NSString     *decimalSeparator;
@property( copy) NSString     *thousandSeparator;
@property( retain) NSNumber   *minimum;
@property( retain) NSNumber   *maximum;


+ (NSNumberFormatterBehavior) defaultFormatterBehavior;
+ (void) setDefaultFormatterBehavior:(NSNumberFormatterBehavior) behavior;

- (BOOL) allowsFloats;
- (BOOL) generatesDecimalNumbers;
- (BOOL) hasThousandSeparators;
- (void) setAllowsFloats:(BOOL) flag;
- (void) setGeneratesDecimalNumbers:(BOOL) flag;
- (void) setHasThousandSeparators:(BOOL) flag;

- (NSNumber *) numberFromString:(NSString *) string;
- (NSString *) stringFromNumber:(NSNumber *) number;

@end


@interface NSNumberFormatter (Localization)

- (BOOL) localizesFormat;
- (void) setLocalizesFormat:(BOOL)flag;

@end

