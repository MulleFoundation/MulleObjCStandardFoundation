/*
 *  _NSEOFoundation - Base Functionality of _NSEOF (Project Titmouse) 
 *                      Part of the _NS EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _NS kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSProxy+NSKVCInformation.m,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import "NSProxy+NSKVCInformation.h"

#import "_MulleObjCKeyValueCodingFoundation.h"


@implementation NSProxy ( _NSKVCInformation)

+ (void) _divineTakeStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                               key:(NSString *) key
{
   __NSDivineTakeStoredValueForKeyKVCInformation( info, self, key, _NSKVCGenericMethodOnly);
}


+ (void) _divineTakeValueForKeyKVCInformation:(_NSKVCInformation *) info
                                         key:(NSString *) key
{
   __NSDivineTakeValueForKeyKVCInformation( info, self, key, _NSKVCGenericMethodOnly);
}


+ (void) _divineStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                           key:(NSString *) key
{
   __NSDivineStoredValueForKeyKVCInformation( info, self, key, _NSKVCGenericMethodOnly);
}


+ (void) _divineValueForKeyKVCInformation:(_NSKVCInformation *) info
                                     key:(NSString *) key
{
   __NSDivineValueForKeyKVCInformation( info, self, key, _NSKVCGenericMethodOnly);
}

@end
