//
//  NSThread+NSNotification.m
//  MulleObjCFoundation
//
//  Created by Nat! on 11.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSThread+NSNotification.h"

// other files in this library
#import "NSNotificationCenter.h"


NSString  *NSWillBecomeMultiThreadedNotification = @"NSWillBecomeMultiThreadedNotification";

@implementation NSThread (NSNotification)

+ (void) _isGoingMultiThreaded
{
   [[NSNotificationCenter defaultCenter] postNotificationName:NSWillBecomeMultiThreadedNotification
    object:nil];
}

@end
