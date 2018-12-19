//
//  NSDate+NSDateFormatter.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 27.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSDate+NSDateFormatter.h"

// other files in this library
#import "NSDateFormatter.h"
#import "NSTimeZone.h"

// std-c and dependencies


@implementation NSDate (NSDateFormatter)

static NSString   *NSDateDefaultFormat = @"%Y-%m-%d %H:%M:%S %z";

// lame code, fix later
- (instancetype) initWithString:(NSString *) s
{
   id   old;

   old  = self;
   self = [[[self class] dateWithString:s] retain];
   [old release];
   return( self);
}


- (instancetype) initWithTimeintervalSince1970:(NSTimeInterval) interval
                            timeZone:(NSTimeZone *) timeZone
{
   interval -= [timeZone secondsFromGMT];
   return( [self initWithTimeIntervalSince1970:interval]);
}



+ (instancetype) dateWithString:(NSString *) s
{
   NSDateFormatter   *formatter;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:NSDateDefaultFormat
    allowNaturalLanguage:NO] autorelease];
   return( [formatter dateFromString:s]);
}


- (NSString *) descriptionWithCalendarFormat:(NSString *) format
                                    timeZone:(NSTimeZone *) tz
                                      locale:(id) locale
{
   NSDateFormatter   *formatter;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:format
                                       allowNaturalLanguage:YES] autorelease];
   [formatter setTimeZone:tz];
   [formatter setLocale:locale];
   return( [formatter stringFromDate:self]);
}


#pragma mark - use formatter for description

- (NSString *) description
{
   NSDateFormatter  *formatter;

   formatter = [[[NSDateFormatter alloc] init] autorelease];
   return( [formatter stringFromDate:self]);
}


- (NSString *) descriptionWithLocale:(NSLocale *) locale
{
   NSDateFormatter    *formatter;

   // if this is too slow, but a default formatter into class vars

   formatter = [[NSDateFormatter new] autorelease];
   [formatter setLocale:locale];
   return( [formatter stringFromDate:self]);
}

@end
