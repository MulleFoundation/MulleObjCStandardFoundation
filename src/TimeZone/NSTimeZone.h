//
//  NSTimeZone.h
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
#import "import.h"


@class NSArray;
@class NSData;
@class NSDate;
@class NSString;
@class NSDictionary;

//
// this class is not functional on its own. Categories must implement
// all methods defined in NSTimeZone+_Abstract
// and all methods declared in NSTimeZone+_Abstract_NSDate
//
@interface NSTimeZone : NSObject < MulleObjCInvariant, NSCopying, MulleObjCImmutableProtocols>
{
   NSString   *_name;
   NSData     *_data;
   NSInteger  _secondsFromGMT;  // if NSIntegerMax unset
}

// Primary creation method is +timeZoneWithName:; the
// data-taking variants should rarely be used directly

+ (instancetype) timeZoneWithName:(NSString *) name;
+ (instancetype) timeZoneWithName:(NSString *) name
                             data:(NSData *) data;

- (instancetype) initWithName:(NSString *) name
                         data:(NSData *) data;

// Time zones created with this never have daylight savings and the
// offset is constant no matter the date; the name and abbreviation
// do NOT follow the Posix convention (of minutes-west).
+ (instancetype) timeZoneWithAbbreviation:(NSString *) abbreviation;
+ (NSTimeZone *) timeZoneForSecondsFromGMT:(NSInteger) seconds;

- (NSString *) name;
- (NSData *) data;

+ (NSTimeZone *) systemTimeZone;
+ (void) resetSystemTimeZone;

+ (NSTimeZone *) defaultTimeZone;
+ (void) setDefaultTimeZone:(NSTimeZone *) tz;

+ (NSTimeZone *) localTimeZone;

- (BOOL) isEqualToTimeZone:(NSTimeZone *) tz;

- (NSInteger) secondsFromGMT;
- (NSString *) abbreviation;
- (BOOL) isDaylightSavingTime;
- (NSString *) description;

// mulle addition
+ (NSTimeZone *) mulleGMTTimeZone;

@end


@interface NSTimeZone( Future)

- (instancetype) initWithName:(NSString *) name;
- (instancetype) timeZoneForSecondsFromGMT:(NSInteger) seconds;

+ (NSTimeZone  *) _uncachedSystemTimeZone;
+ (NSArray *) knownTimeZoneNames;
+ (NSDictionary *) abbreviationDictionary;

- (NSInteger) mulleSecondsFromGMTForTimeIntervalSince1970:(NSTimeInterval) interval;
- (NSInteger) secondsFromGMTForDate:(NSDate *) date;
- (NSString *) abbreviationForDate:(NSDate *) aDate;
- (BOOL) isDaylightSavingTimeForDate:(NSDate *) aDate;

@end
