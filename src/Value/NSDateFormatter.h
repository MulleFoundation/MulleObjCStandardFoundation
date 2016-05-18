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

//
enum 
{
   NSDateFormatterBehaviorDefault = 0,
   NSDateFormatterBehavior10_0    = 1000,
   NSDateFormatterBehavior10_4    = 1040,
};

typedef NSUInteger   NSDateFormatterBehavior;

extern NSString  *NSDateFormatter1000BehaviourClassKey;
extern NSString  *NSDateFormatter1040BehaviourClassKey;


@interface NSDateFormatter : NSFormatter
{
   id      _locale;
   id      _timeZone;
   Class   _dateClass;

   // for 1000 formatter
   char     *_cformat;
   size_t   _buflen;
   
   // for 1040 formatter
}

@property( copy)     NSString   *dateFormat;
@property( readonly) BOOL       allowsNaturalLanguage;
@property( assign)   BOOL       generateCalendarDates;
@property( assign, getter=isLenient) BOOL  lenient;



- (id) initWithDateFormat:(NSString *) format 
     allowNaturalLanguage:(BOOL) flag;

+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior;
+ (NSDateFormatterBehavior) defaultFormatterBehavior;

// this changes the class of the formatter!
- (void) setFormatterBehavior:(NSDateFormatterBehavior) behavior;
- (NSDateFormatterBehavior) formatterBehavior;

@end


@interface NSDateFormatter ( Subclasses)

- (id) _initWithDateFormat:(NSString *) format
      allowNaturalLanguage:(BOOL) flag;

- (NSDate *) dateFromString:(NSString *) s;
- (NSString *) stringFromDate:(NSDate *) date;

@end



