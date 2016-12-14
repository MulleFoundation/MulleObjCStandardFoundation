//
//  NSDate.h
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
#import <MulleObjC/MulleObjC.h>


typedef double    NSTimeInterval;

#define NSTimeIntervalSince1970  978307200.0


@interface NSDate : NSObject < NSCoding>
{
   NSTimeInterval   _interval;
}

+ (id) date;

+ (id) dateWithTimeIntervalSince1970:(NSTimeInterval) seconds;
+ (id) dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval) seconds;
+ (id) distantFuture;
+ (id) distantPast;

- (id) initWithTimeInterval:(NSTimeInterval) seconds 
                  sinceDate:(NSDate *) refDate;
- (id) initWithTimeIntervalSince1970:(NSTimeInterval) seconds;
- (id) initWithTimeIntervalSinceReferenceDate:(NSTimeInterval) seconds;

- (NSComparisonResult) compare:(id) other;
- (id) dateByAddingTimeInterval:(NSTimeInterval) seconds;
- (NSDate *) earlierDate:(NSDate *) other;
- (NSTimeInterval) timeIntervalSince1970;
- (NSTimeInterval) timeIntervalSinceDate:(NSDate *) other;
- (NSTimeInterval) timeIntervalSinceReferenceDate;
+ (NSTimeInterval) timeIntervalSinceReferenceDate;

@end
