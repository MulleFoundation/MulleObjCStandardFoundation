//
//  NSCalendarDate.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 05.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "import.h"


@class NSArray;
@class NSString;
@class NSDictionary;
@class NSTimeZone;

#include "mulle-mini-tm.h"


//
// A NSCalendarDate is a "human" representation of what a date is.
// In does not deal fractions of seconds. It is integer based.
//
// The old NSCalendarDate was mutable with respect to NSTimeZone
// and the calendarFormat, this is no longer the case
//
// Equality: Should a NSCalendarDate for 12:00 CEST equal to 11:00 CET ?
// The point in time is equal, but the timezones are not. So they
// are equal as NSDate but not equal as NSCalendarDates.
//
// For portability, there is quite a bit of conversion capability
// with NSDate. But in general the concept of timeInterval is not as
// meaningful with NSCalendarDate. If you are dealing with
// NSTimeInterval, look for NSDate. If you need subsecond precision use
// use NSDate. If you need location with your date, use a separate timeZone
// variable.
//
// A NSCalendarDate in this Foundation _always_ has a timeZone.
//
@interface NSCalendarDate : NSDate < NSDateFactory, MulleObjCClassCluster, MulleObjCValueProtocols>

+ (instancetype) calendarDate;

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


//
// this is fetched dynamically from current locale
// it's basically useless currently
//
- (NSString *) calendarFormat;

- (instancetype) mulleInitWithMiniTM:(struct mulle_mini_tm) tm
                            timeZone:(NSTimeZone *) tz;
@end


@interface NSCalendarDate( Subclasses)

- (struct mulle_mini_tm) mulleMiniTM;
- (NSInteger) secondOfMinute;
- (NSInteger) minuteOfHour;
- (NSInteger) hourOfDay;
- (NSInteger) dayOfMonth;
- (NSInteger) monthOfYear;
- (NSInteger) yearOfCommonEra;
- (NSTimeZone *) timeZone;

- (BOOL) isEqualToCalendarDate:(NSCalendarDate *) date;

@end


@class NSDate;

@interface NSCalendarDate( Future)

// TODO: check which ones are compatible
- (instancetype) initWithDate:(NSDate *) date;
- (instancetype) mulleInitWithDate:(NSDate *) date
                          timeZone:(NSTimeZone *) tz;

- (instancetype) initWithTimeIntervalSince1970:(NSTimeInterval) timeInterval;
- (instancetype) mulleInitWithTimeIntervalSince1970:(NSTimeInterval) interval
                                           timeZone:(NSTimeZone *) tz;
- (instancetype) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval) timeInterval;
- (instancetype) mulleInitWithTimeIntervalSinceReferenceDate:(NSTimeInterval) interval
                                                    timeZone:(NSTimeZone *) tz;

- (NSInteger) dayOfWeek;
- (NSInteger) dayOfYear;
- (instancetype) dateByAddingYears:(NSInteger) year
                            months:(NSInteger) month
                              days:(NSInteger) day
                             hours:(NSInteger) hour
                           minutes:(NSInteger) minute
                           seconds:(NSInteger) second;

- (NSDate *) date;

@end
