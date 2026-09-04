//
//  NSDate+NSDateFormatter.m
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

   formatter = [[NSDateFormatter new] autorelease];
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


- (NSString *) stringValue
{
   return( [self descriptionWithLocale:nil]);
}

@end
