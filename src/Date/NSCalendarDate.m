//
//  NSCalendarDate.m
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

