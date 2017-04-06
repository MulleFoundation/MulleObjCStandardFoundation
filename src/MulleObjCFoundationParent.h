//
//  MulleObjCFoundationParent.h
//  MulleObjCFoundation
//
//  Created by Nat! on 29.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//


// this is the central place to read MulleObjC.h
// only some "C" code may bypass this header and read some MulleObjC files
// directly

@class NSException;
@class NSString;

#define MULLE_OBJC_EXCEPTION_CLASS_P  NSException *
#define MULLE_OBJC_STRING_CLASS_P     NSString *

#import <MulleObjC/MulleObjC.h>


