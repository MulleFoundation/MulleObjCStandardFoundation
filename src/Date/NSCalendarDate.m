//
//  NSCalendarDate.m
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 05.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
// define, that make things POSIXly
#define _XOPEN_SOURCE 700

#import "NSCalendarDate.h"

// other files in this library
#import "NSTimeZone.h"
#import "NSLocale.h"
#import "NSDateFormatter.h"
#import "_MulleObjCConcreteCalendarDate.h"

//
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and dependencies

@implementation NSObject( _NSCalendarDate)

- (BOOL) __isNSCalendarDate
{
   return( NO);
}

@end


@implementation NSCalendarDate

- (BOOL) __isNSCalendarDate
{
   return( YES);
}


+ (instancetype) calendarDate
{
   return( [[self new] autorelease]);
}


- (NSString *) calendarFormat
{
   return( [[NSLocale currentLocale] objectForKey:NSTimeDateFormatString]);
}


- (instancetype) mulleInitWithMiniTM:(struct mulle_mini_tm) tm
                            timeZone:(NSTimeZone *) tz
{
   return( [_MulleObjCConcreteCalendarDate newWithMiniTM:tm
                                                timeZone:tz]);
}


- (instancetype) initWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour
                       minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) tz
{
   struct mulle_mini_tm   tm;

   NSParameterAssert( year >= mulle_mini_tm_min_year && year <= mulle_mini_tm_max_year);
   NSParameterAssert( month >= 1 && month <= 12);
   NSParameterAssert( day >= 1 && day <= 31);
   NSParameterAssert( hour >= 0 && hour <= 23);
   NSParameterAssert( minute >= 0 && minute <= 59);
   NSParameterAssert( second >= 0 && second <= 60);

   tm.type   = 0;
   tm.year   = (int) year;
   tm.month  = (int) month;
   tm.day    = (int) day;
   tm.hour   = (int) hour;
   tm.minute = (int) minute;
   tm.second = (int) second;

   return( [self mulleInitWithMiniTM:tm
                            timeZone:tz]);
}


+ (instancetype) dateWithYear:(NSInteger) year
                        month:(NSUInteger) month
                          day:(NSUInteger) day
                         hour:(NSUInteger) hour
                       minute:(NSUInteger) minute
                       second:(NSUInteger) second
                     timeZone:(NSTimeZone *) tz
{
   return( [[[self alloc] initWithYear:year
                                 month:month
                                   day:day
                                  hour:hour
                                minute:minute
                                second:second
                              timeZone:tz] autorelease]);
}

@end

