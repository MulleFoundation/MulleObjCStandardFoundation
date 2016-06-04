/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSLock.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSLock+NSDate.h"

// other files in this library
#import "NSDate.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies



@implementation NSLock (NSDate)


- (BOOL) lockBeforeDate:(NSDate *) limit
{
   time_t   wait_time;

   wait_time = (time_t) [limit timeIntervalSinceReferenceDate];  

   for(;;)
   {
      if( [NSDate timeIntervalSinceReferenceDate] >= wait_time)
         return( NO);
      
      if( [self tryLock])
         return( YES);

      mulle_thread_yield();
   }
}

@end



