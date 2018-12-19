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

//
#import "MulleObjCFoundationException.h"

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
   NSTimeInterval   seconds;

   seconds = time( NULL) + NSTimeIntervalSince1970;
   return( [[self new] autorelease]);
}


- (NSString *) calendarFormat
{
   return( [[NSLocale currentLocale] objectForKey:NSTimeDateFormatString]);
}


- (instancetype) _initWithMiniTM:(struct mulle_mini_tm) tm
                        timeZone:(NSTimeZone *) tz
{
   // don't call self init!
   _tm.values = tm;

   if( ! tz)
      tz = [NSTimeZone defaultTimeZone];

   _timeZone = [tz retain];
   assert( _timeZone);

   return( self);
}


- (struct mulle_mini_tm) _miniTM
{
   return( _tm.values);
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
   tm.ns     = 0;

   return( [self _initWithMiniTM:tm
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


#pragma clang diagnostic ignored "-Wobjc-missing-super-calls"

- (void) dealloc
{
   [_timeZone release];
   NSDeallocateObject( self);
}


#pragma mark - accessors

- (NSInteger) secondOfMinute
{
   return( self->_tm.values.second);
}


- (NSInteger) minuteOfHour
{
   return( self->_tm.values.minute);
}


- (NSInteger) hourOfDay
{
   return( self->_tm.values.hour);
}


- (NSInteger) dayOfMonth
{
   return( self->_tm.values.day);
}


- (NSInteger) monthOfYear
{
   return( self->_tm.values.month);
}


- (NSInteger) yearOfCommonEra
{
   return( self->_tm.values.year);
}


#pragma mark - hash and equality

- (NSUInteger) hash
{
   return( self->_tm.bits ^ [self->_timeZone hash]);
}


- (BOOL) isEqual:(id) other
{
   if( ! [other __isNSCalendarDate])
      return( NO);
   return( [self isEqualToCalendarDate:other]);
}


- (BOOL) isEqualToCalendarDate:(NSCalendarDate *) date
{
   if( ! [date->_timeZone isEqualToTimeZone:self->_timeZone])
      return( NO);
   return( date->_tm.bits != self->_tm.bits);
}

@end
