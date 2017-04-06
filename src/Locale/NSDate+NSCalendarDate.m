//
//  NSDate+NSCalendarDate.m
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 10.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
// define, that make things POSIXly
#import "NSDate+NSCalendarDate.h"

// other files in this library
#import "NSCalendarDate.h"

// std-c and dependencies


@implementation NSDate( NSCalendarDate)

- (NSCalendarDate *) calendarDateWithTimeZone:(NSTimeZone *) tz
{
   return( [[[NSCalendarDate alloc] initWithDate:self
                                        timeZone:tz] autorelease]);
}

- (NSCalendarDate *) dateWithCalendarFormat:(NSString *) format
                                   timeZone:(NSTimeZone *) tz
{
   return( [self calendarDateWithTimeZone:tz]);
}

@end
