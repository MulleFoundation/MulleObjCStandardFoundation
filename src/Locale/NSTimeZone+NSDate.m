/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSTimeZone+NSDate.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSTimeZone+NSDate.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and dependencies



@implementation NSTimeZone( NSDate)

- (NSInteger) secondsFromGMT
{
   return( [self secondsFromGMTForDate:[NSDate date]]);
}


- (NSString *) abbreviation
{
   return( [self abbreviationForDate:[NSDate date]]);
}


- (BOOL) isDaylightSavingTime
{
   return( [self isDaylightSavingTimeForDate:[NSDate date]]);
}


- (id) description
{
   return( [NSString stringWithFormat:@"%@ (%@) offset %ld%s",
                                 _name, 
                                 [self abbreviation], 
                                 [self secondsFromGMT], 
                                 [self isDaylightSavingTime] ? " (Daylight)" : ""]);
}

@end
