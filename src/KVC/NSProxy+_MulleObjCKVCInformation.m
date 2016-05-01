/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSProxy+NSKVCInformation.m,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import <MulleObjC/MulleObjC.h>

// other files in this library
#import "NSObject+KeyValueCoding.h"
#import "_MulleObjCKVCInformation.h"

// other libraries of MulleObjCFoundation

// std-c and other dependencies


@implementation NSProxy ( _MulleObjCKVCInformation)

+ (void) _divineTakeStoredValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                               key:(NSString *) key
{
   __MulleObjCDivineTakeStoredValueForKeyKVCInformation( info, self, key, _MulleObjCKVCGenericMethodOnly);
}


+ (void) _divineTakeValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                          key:(NSString *) key
{
   __MulleObjCDivineTakeValueForKeyKVCInformation( info, self, key, _MulleObjCKVCGenericMethodOnly);
}


+ (void) _divineStoredValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                            key:(NSString *) key
{
   __MulleObjCDivineStoredValueForKeyKVCInformation( info, self, key, _MulleObjCKVCGenericMethodOnly);
}


+ (void) _divineValueForKeyKVCInformation:(struct _MulleObjCKVCInformation *) info
                                      key:(NSString *) key
{
   __MulleObjCDivineValueForKeyKVCInformation( info, self, key, _MulleObjCKVCGenericMethodOnly);
}

@end
