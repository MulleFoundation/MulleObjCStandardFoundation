/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSDate.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
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

