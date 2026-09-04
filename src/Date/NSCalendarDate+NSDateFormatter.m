//
//  NSCalendarDate+NSDateFormatter.m
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
