//
//  NSDateFormatter.h
//  MulleObjCFoundation
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

#import "NSLocalizedDateFactory.h"


@class NSDate;
@class NSLocale;
@class NSString;
@class NSTimeZone;

//
enum
{
   NSDateFormatterBehaviorDefault = 0,
   NSDateFormatterBehavior10_0    = 1000,
   NSDateFormatterBehavior10_4    = 1040,
};

typedef NSUInteger   NSDateFormatterBehavior;

extern NSString  *NSDateFormatter1000BehaviourClassKey;
extern NSString  *NSDateFormatter1040BehaviourClassKey;


//
// formatters are not re-entrant!
// For historical reasons, there is only an NSDateFormatter and
// no NSCalendarDate formatter
//
// Eventually there will be a NSDateObject protocol or some such
// so that it fits both better
//
@interface NSDateFormatter : NSFormatter
{
   Class< NSLocalizedDateFactory>   _dateClass;

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

- (BOOL) generateCalendarDates;
- (void) setGenerateCalendarDates:(BOOL) flag;

@end


@interface NSDateFormatter ( Future)

- (instancetype) _initWithDateFormat:(NSString *) format
                allowNaturalLanguage:(BOOL) flag;

- (NSDate *) dateFromString:(NSString *) s;
- (NSString *) stringFromDate:(NSDate *) date;

@end
