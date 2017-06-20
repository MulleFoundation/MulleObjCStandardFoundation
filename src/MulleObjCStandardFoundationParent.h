//
//  MulleObjCFoundationParent.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 29.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//


// this is the central place to read MulleObjC.h
// only some "C" code may bypass this header and read some MulleObjC files
// directly

@class NSException;
@class NSString;

#ifdef MULLE_OBJC_EXCEPTION_CLASS_P
# error "MULLE_OBJC_EXCEPTION_CLASS_P has already been defined, do not import MulleObjC before MulleObjCStandardFoundation"
#endif

#define MULLE_OBJC_EXCEPTION_CLASS_P  NSException *
#define MULLE_OBJC_STRING_CLASS_P     NSString *

#import <MulleObjC/MulleObjC.h>


