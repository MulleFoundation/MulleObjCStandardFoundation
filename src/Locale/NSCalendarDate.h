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

// 64 bit large
struct mulle_mini_tm
{
   int              year    : 18;   // -100000  +100000 (?)
   unsigned int     month   : 4;    // 1-12 (15)
   unsigned int     day     : 5;    // 1-31 (31)
   unsigned int     hour    : 5;    // 0-23 (31)
   unsigned int     minute  : 6;    // 0-59 (63)
   unsigned int     second  : 6;    // 0-59 (63)
   unsigned int     ns      : 20;   // 0-999 (1023)  **unused **
};


//
// A NSCalendarDate is NOT really an NSDate
// This is a misdesign perpertrated since OpenStep
// Also the old NSCalendarDate was mutable with respect to NSTimeZone
// and the calendarFormat, this is no longer the case

@interface NSCalendarDate : NSObject < NSDateFactory>
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

@end


@class NSDate;

@interface NSCalendarDate( Future)

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

