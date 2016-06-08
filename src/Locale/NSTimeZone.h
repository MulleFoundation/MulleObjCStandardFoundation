/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSTimeZone.h is a part of MulleFoundation
 *
 *  Copyright (C)  2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>


@class NSArray;
@class NSData;
@class NSString;
@class NSDictionary;

//
// this class is not functional on its own. Categories must implement
// all methods defined in NSTimeZone+_Abstract
// and all methods declared in NSTimeZone+_Abstract_NSDate
// 
@interface NSTimeZone : NSObject <NSCopying> 
{
   NSString   *_name;
   NSData     *_data;
}

// Primary creation method is +timeZoneWithName:; the
// data-taking variants should rarely be used directly

+ (id) timeZoneWithName:(NSString *) name;
+ (id) timeZoneWithName:(NSString *) name 
                   data:(NSData *) data;

- (id) initWithName:(NSString *) name 
               data:(NSData *) data;

// Time zones created with this never have daylight savings and the
// offset is constant no matter the date; the name and abbreviation
// do NOT follow the Posix convention (of minutes-west).
+ (id) timeZoneWithAbbreviation:(NSString *) abbreviation;

- (NSString *) name;
- (NSData *) data;

+ (NSTimeZone *) systemTimeZone;
+ (void) resetSystemTimeZone;

+ (NSTimeZone *) defaultTimeZone;
+ (void) setDefaultTimeZone:(NSTimeZone *) tz;

+ (NSTimeZone *) localTimeZone;

- (BOOL) isEqualToTimeZone:(NSTimeZone *) tz;

@end


@class NSDate;


@interface NSTimeZone( _Abstract)

- (id) initWithName:(NSString *) name;
+ (NSTimeZone  *) _uncachedSystemTimeZone;
+ (NSArray *) knownTimeZoneNames;
+ (NSDictionary *) abbreviationDictionary;

- (NSInteger) secondsFromGMT;
- (NSInteger) secondsFromGMTForDate:(NSDate *) date;

@end

