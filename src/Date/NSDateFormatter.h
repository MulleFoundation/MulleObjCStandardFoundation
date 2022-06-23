//
//  NSDateFormatter.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "NSFormatter.h"


@class NSDate;
@class NSLocale;
@class NSString;
@class NSTimeZone;
@class NSError;


//
enum
{
   NSDateFormatterBehaviorDefault = 0,
   NSDateFormatterBehavior10_0    = 1000,
   NSDateFormatterBehavior10_4    = 1040,
};

typedef NSUInteger   NSDateFormatterBehavior;

// MEMO: this vanished. why ?
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
NSString  *MulleDateFormatISOWithMilliseconds; // = @"%Y-%m-%dT%H:%M:%S:%F%z";

// this is the default
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL
NSString  *MulleDateFormatISO;                 //  = @"%Y-%m-%dT%H:%M:%S:%z";


//
// formatters are not re-entrant!
// For historical reasons, there is only a NSDateFormatter and
// no NSCalendarDate formatter
//
// Eventually there will be a NSDateObject protocol or some such
// so that it fits both better
//
@interface NSDateFormatter : NSFormatter
{
   Class    _dateClass;

   // for 1000 formatter
   char     *_cformat;
   size_t   _buflen;

   // for 1040 formatter
}

@property( retain) NSTimeZone   *timeZone;
@property( retain) NSLocale     *locale;
@property( copy)   NSString     *dateFormat;
@property( readonly) BOOL       allowsNaturalLanguage;
@property( assign, getter=isLenient) BOOL  lenient;

- (instancetype) initWithDateFormat:(NSString *) format
               allowNaturalLanguage:(BOOL) flag;

+ (void) setDefaultFormatterBehavior:(NSDateFormatterBehavior) behavior;
+ (NSDateFormatterBehavior) defaultFormatterBehavior;

// this changes the class of the formatter!
- (void) setFormatterBehavior:(NSDateFormatterBehavior) behavior;
- (NSDateFormatterBehavior) formatterBehavior;

- (BOOL) generatesCalendarDates;
- (void) setGeneratesCalendarDates:(BOOL) flag;

//
+ (void) mulleSetClass:(Class) cls
  forFormatterBehavior:(NSDateFormatterBehavior) formatterBehavior;

@end


@interface NSDateFormatter( Future)

- (instancetype) _initWithDateFormat:(NSString *) format
                allowNaturalLanguage:(BOOL) flag;

- (NSDate *) dateFromString:(NSString *) s;
- (NSString *) stringFromDate:(NSDate *) date;

- (BOOL) getObjectValue:(id *) obj
              forString:(NSString *) string
                  range:(NSRange *) rangep
                  error:(NSError **) error;
@end
