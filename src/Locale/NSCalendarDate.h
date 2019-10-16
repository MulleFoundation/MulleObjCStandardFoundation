//
//  NSCalendarDate.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 05.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"


@class NSArray;
@class NSString;
@class NSDictionary;
@class NSTimeZone;

#define mulle_mini_tm_min_year ((int) (~0UL << 17))
#define mulle_mini_tm_max_year ((int) (1UL << 17))

// 64 bit large, if we support other calendars make
// another struct and put it in the union
struct mulle_mini_tm
{
   unsigned int     type    : 1;    // 0: gregorian, 1: other
   int              year    : 17;   // -100000  +100000 (?)
   unsigned int     month   : 4;    // 1-12 (15)
   unsigned int     day     : 5;    // 1-31 (31)
   unsigned int     hour    : 5;    // 0-23 (31)
   unsigned int     minute  : 6;    // 0-59 (63)
   unsigned int     second  : 6;    // 0-59 (63)
   unsigned int     ms      : 10;   // 0-999 (1023)  **unused **
   unsigned int     ns      : 10;   // 0-999 (1023)  **unused **
};


//
// A NSCalendarDate is a "human" representation of what a date is.
// In does not deal fractions of seconds. It is integer based,
// therefore you can not compare NSDates with it properly.
//
// The old NSCalendarDate was mutable with respect to NSTimeZone
// and the calendarFormat, this is no longer the case
//
// Equality: Should a NSCalendarDate for 12:00 CEST equal to 11:00 CET ?
// The point in time is equal, but the timezones are not. So they
// are not equal. Otherwise an interesting piece of information would not
// be considered and lost if both were placed into NSSet and only one
// would randomly win.
//
// For portability, there is quite a bit of conversion capability
// with NSDate. But in general the concept of timeInterval is not
// meaningful with NSCalendarDate. If you are dealing with
// NSTimeInterval, look for NSDate.
//
// A NSCalendarDate in this Foundation _always_ has a timeZone.
//
@interface NSCalendarDate : NSObject < NSDateFactory, MulleObjCImmutable>
{
   union
   {
      uint64_t               bits;
      struct mulle_mini_tm   values;
   } _tm;
   NSTimeZone                *_timeZone; // 4 categories
}

@property( retain, readonly) NSTimeZone   *timeZone;

+ (instancetype) dateWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour
                       minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) aTimeZone;

- (instancetype) initWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) aTimeZone;

+ (instancetype) dateWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour
                       minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) aTimeZone;


//- (NSInteger) dayOfCommonEra;
- (NSInteger) hourOfDay;
- (NSInteger) minuteOfHour;
- (NSInteger) dayOfMonth;
- (NSInteger) monthOfYear;
- (NSInteger) secondOfMinute;
- (NSInteger) yearOfCommonEra;

//
// this is fetched dynamically from current locale
// it's basically useless now
//
- (NSString *) calendarFormat;

- (BOOL) isEqualToCalendarDate:(NSCalendarDate *) date;

- (instancetype) mulleInitWithMiniTM:(struct mulle_mini_tm) tm
                        timeZone:(NSTimeZone *) tz;
@end


@class NSDate;

@interface NSCalendarDate( Future)

- (instancetype) init:(NSDate *) date;
- (instancetype) _initWithDate:(NSDate *) date;
- (instancetype) initWithDate:(NSDate *) date
                     timeZone:(NSTimeZone *) tz;
- (NSInteger) dayOfWeek;
- (NSInteger) dayOfYear;
+ (instancetype) calendarDate;
- (instancetype) dateByAddingYears:(NSInteger) year
                            months:(NSInteger) month
                              days:(NSInteger) day
                             hours:(NSInteger) hour
                           minutes:(NSInteger) minute
                           seconds:(NSInteger) second;

@end


@interface NSCalendarDate( NSDateFuture)

// NSDate compatibility
- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) timeInterval;
- (instancetype) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval) timeInterval;
- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) timeInterval
                                      timeZone:(NSTimeZone *) timeZone;

- (NSTimeInterval) timeIntervalSinceReferenceDate;
- (NSTimeInterval) timeIntervalSince1970;
- (NSDate *) date;

@end


