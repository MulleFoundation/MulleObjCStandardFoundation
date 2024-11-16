//
//  NSThread+NSNotification.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 11.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSThread+NSNotification.h"

// other files in this library
#import "NSNotificationCenter.h"

#import "NSException.h"


NSString  *NSWillBecomeMultiThreadedNotification = @"NSWillBecomeMultiThreadedNotification";
NSString  *NSDidBecomeSingleThreadedNotification = @"NSDidBecomeSingleThreadedNotification";
NSString  *NSThreadWillExitNotification          = @"NSThreadWillExitNotification";


@implementation NSThread( NSNotification)

static struct
{
   BOOL  _notificationsEnabled;
} Self;


//
// Enable notifications to be turned off, because I am not to keen on
// NSNotifications anymore
//
+ (void) load
{
   Self._notificationsEnabled = mulle_objc_environment_get_yes_no_default( "NSTHREAD_NOTIFICATIONS", YES);
}


- (void) _isGoingMultiThreaded
{
   if( Self._notificationsEnabled)
      [[NSNotificationCenter defaultCenter] postNotificationName:NSWillBecomeMultiThreadedNotification
       object:nil];
}


- (void) _isProbablyGoingSingleThreaded
{
   if( Self._notificationsEnabled)
      [[NSNotificationCenter defaultCenter] postNotificationName:NSDidBecomeSingleThreadedNotification
       object:nil];
}


- (void) _threadWillExit
{
   if( Self._notificationsEnabled)
      [[NSNotificationCenter defaultCenter] postNotificationName:NSThreadWillExitNotification
                                                          object:self];
}

@end
