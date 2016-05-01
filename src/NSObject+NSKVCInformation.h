/*
 *  _NSEOFoundation - Base Functionality of _NSEOF (Project Titmouse) 
 *                      Part of the _NS EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _NS kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCInformation.h,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import "_NSKVCInformation.h"


@interface NSObject ( _NSKVCInformation)

+ (void) _divineTakeStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                                key:(NSString *) key;

+ (void) _divineTakeValueForKeyKVCInformation:(_NSKVCInformation *) info
                                          key:(NSString *) key;

+ (void) _divineStoredValueForKeyKVCInformation:(_NSKVCInformation *) info
                                            key:(NSString *) key;

+ (void) _divineValueForKeyKVCInformation:(_NSKVCInformation *) info
                                      key:(NSString *) key;

+ (unsigned int) _kvcMaskForMethodOfType:(_NSKVCMethodType) type;

@end
