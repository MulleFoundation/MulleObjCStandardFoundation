//
//  NSCalendarDate+NSDateFormatter.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSCalendarDate+NSDateFormatter.h"

#import "NSLocale.h"
#import "NSDateFormatter.h"


@implementation NSCalendarDate (NSDateFormatter)

+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(NSLocale *) locale
{
   NSDateFormatter   *formatter;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:format
                                       allowNaturalLanguage:YES] autorelease];
   [formatter setGeneratesCalendarDates:YES];
   [formatter setLocale:locale];

   return( (NSCalendarDate *) [formatter dateFromString:s]);
}


+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format
{
   return( [self dateWithString:s
                 calendarFormat:format
                         locale:[NSLocale currentLocale]]);
}


- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(id) locale
{
   NSDateFormatter   *formatter;
   id                old;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:format
                                       allowNaturalLanguage:YES] autorelease];
   [formatter setGeneratesCalendarDates:YES];
   [formatter setLocale:locale];

   old  = self;
   self = (id) [[formatter dateFromString:s] retain];
   [old release];

   return( self);
}


- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format
{
   NSLocale   *locale;

   locale = [NSLocale currentLocale];
   return( [self initWithString:s
                          calendarFormat:format
                                  locale:locale]);
}


- (instancetype) initWithString:(NSString *) s;
{
   NSLocale   *locale;

   locale = [NSLocale currentLocale];
   return( [self initWithString:s
                  calendarFormat:[locale objectForKey:NSTimeDateFormatString]
                          locale:locale]);
}


- (NSString *) descriptionWithCalendarFormat:(NSString *) format
                                      locale:(id) locale
{
   NSDateFormatter   *formatter;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:format
                                       allowNaturalLanguage:YES] autorelease];
   [formatter setGeneratesCalendarDates:YES];
   [formatter setLocale:locale];

   return( [formatter stringForObjectValue:self]);
}


- (NSString *) descriptionWithCalendarFormat:(NSString *) format
                                    timezone:(NSTimeZone *) timezone
                                      locale:(id) locale
{
   NSDateFormatter   *formatter;

   formatter = [[[NSDateFormatter alloc] initWithDateFormat:format
                                       allowNaturalLanguage:YES] autorelease];
   [formatter setGeneratesCalendarDates:YES];
   [formatter setLocale:locale];
   [formatter setTimeZone:timezone];

   return( [formatter stringForObjectValue:self]);
}


- (NSString *) descriptionWithCalendarFormat:(NSString *) format
{
   NSLocale   *locale;

   locale = [NSLocale currentLocale];
   return( [self descriptionWithCalendarFormat:format
                                        locale:locale]);
}


@end
