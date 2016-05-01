/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSThread+NSDate.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSThread+NSDate.h"


@implementation NSThread( NSDate)

+ (void) sleepUntilDate:(NSDate *) date
{
   NSTimeInterval    interval;

   // should probably use select here
   interval = [date timeIntervalSinceReferenceDate];
   while( [NSDate timeIntervalSinceReferenceDate] < interval)
      mulle_thread_yield();
}

@end
