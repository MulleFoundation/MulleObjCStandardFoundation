/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCInformation.h,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import "_MulleObjCKVCInformation.h"


@interface NSObject ( _MulleObjCKVCInformation)

+ (BOOL) accessInstanceVariablesDirectly;
+ (BOOL) useStoredAccessor;

@end
