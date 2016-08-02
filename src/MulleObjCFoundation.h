//
//  MulleObjCFoundation.h
//  MulleObjCFoundation
//
//  Created by Nat! on 04.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

// keep this in sync with MULLE_OBJC_VERSION, else pain!

#define MULLE_OBJC_FOUNDATION_VERSION   MULLE_OBJC_VERSION

#import "MulleObjCFoundationCore.h"

#import "MulleObjCFoundationArchiver.h"
#import "MulleObjCFoundationKVC.h"
#import "MulleObjCFoundationLocale.h"
#import "MulleObjCFoundationNotification.h"
#import "MulleObjCFoundationPropertyList.h"


#if MULLE_OBJC_VERSION < ((0 << 20) | (4 << 8) | 0)
# error "MulleObjC is too old"
#endif
