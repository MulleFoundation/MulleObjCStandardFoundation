//
//  NSThread+NSNotification.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 11.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "import.h"


@class NSString;


MULLE_OBJC_STANDARD_FOUNDATION_EXTERN_GLOBAL NSString  *NSWillBecomeMultiThreadedNotification; //  = @"NSWillBecomeMultiThreadedNotification";

// this is only true, if the main thread isn't spawning a new NSThread
// while this is sent, so it may not be really true
MULLE_OBJC_STANDARD_FOUNDATION_EXTERN_GLOBAL NSString  *NSDidBecomeSingleThreadedNotification; //  = @"NSDidBecomeSingleThreadedNotification";
MULLE_OBJC_STANDARD_FOUNDATION_EXTERN_GLOBAL NSString  *NSThreadWillExitNotification;          //  = @"NSThreadWillExitNotification";
