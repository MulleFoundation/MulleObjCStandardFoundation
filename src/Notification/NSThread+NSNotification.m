//
//  NSThread+NSNotification.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2017 Nat! - Mulle kybernetiK.
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
