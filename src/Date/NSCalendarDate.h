//
//  NSCalendarDate.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2021 Nat! - Mulle kybernetiK.
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


@interface NSCalendarDate( Subclasses) < MulleObjCFuture>

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

@interface NSCalendarDate( Future) < MulleObjCFuture>

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
