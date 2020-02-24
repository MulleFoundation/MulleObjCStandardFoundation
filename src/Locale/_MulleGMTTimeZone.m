//
//  _MulleGMTTimeZone.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 14.05.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSTimeZone.h"

#import "_MulleGMTTimeZone-Private.h"


@implementation _MulleGMTTimeZone

- (id) __initSingleton        { return( self); }

- (NSInteger) secondsFromGMT  { return( 0); }
- (NSString *) abbreviation   { return( @"GMT"); }
- (BOOL) isDaylightSavingTime { return( NO); }


- (NSInteger) secondsFromGMTForDate:(NSDate *) date   { return( 0); }
- (NSString *) abbreviationForDate:(NSDate *) aDate   { return( @"GMT"); }
- (BOOL) isDaylightSavingTimeForDate:(NSDate *) aDate { return( NO); }

@end


