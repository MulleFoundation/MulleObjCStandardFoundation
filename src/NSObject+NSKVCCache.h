/*
 *  _NSEOFoundation - Base Functionality of _NSEOF (Project Titmouse) 
 *                      Part of the _NS EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _NS kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCCache.h,v 94531dccc5a4 2008/06/05 10:13:59 nat $
 *
 *  $Log$
 */
#import "MulleObjCKeyValueCodingFoundationParentIncludes.h"


@class _NSKVCCache;


@interface NSObject ( _NSKVCCache)

- (id) valueForKey:(NSString *) key
         usingCache:(_NSKVCCache *) cache;  // boring

- (id) valueForKeyPath:(NSString *) path
            usingCache:(_NSKVCCache *) cache;  // interesting

@end
