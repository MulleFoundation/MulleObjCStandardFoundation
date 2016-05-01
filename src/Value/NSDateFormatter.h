/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDateFormatter.h is a part of MulleFoundation
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


@class NSString;
@class NSDate;

enum 
{
   NSDateFormatterBehaviorDefault = 0,
   NSDateFormatterBehavior10_0    = 1000,
   NSDateFormatterBehavior10_4    = 1040,  // sry, do not want
};
typedef NSUInteger   NSDateFormatterBehavior;


@interface NSDateFormatter : NSFormatter
{
   id   _locale;
}

@property( copy)     NSString                  *dateFormat;
@property( readonly) BOOL                      allowsNaturalLanguage;
@property( assign)   NSDateFormatterBehavior   formatterBehavior;


- (id) initWithDateFormat:(NSString *) format 
     allowNaturalLanguage:(BOOL)flag;

+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior;
+ (NSDateFormatterBehavior) defaultFormatterBehavior;

- (NSDate *) dateFromString:(NSString *) s;
- (NSString *) stringFromDate:(NSDate *) date;

@end

