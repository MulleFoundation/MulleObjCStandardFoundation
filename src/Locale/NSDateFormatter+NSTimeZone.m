//
//  NSDateFormatter+NSTimeZone.m
//  MulleObjCFoundation
//
//  Created by Nat! on 05.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSDateFormatter+NSTimeZone.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSDateFormatter (NSTimeZone)

- (NSTimeZone *) timeZone
{
   return( _timeZone);
}


- (void) setTimeZone:(NSTimeZone *) locale
{
   [_timeZone autorelease];
   locale = [_timeZone copy];
}

@end
