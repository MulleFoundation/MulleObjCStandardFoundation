/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCKVCCache.h,v 852ead2c2ba5 2010/11/16 22:03:40 nat $
 *
 *  $Log$
 */
#import <MulleObjC/MulleObjC.h>

#import "ns_hash_table.h"



@class _MulleObjCKVCKeybasedCache;
@class NSString;


struct _MulleObjCKVCCacheline
{
   NSString                     *_key;
   NSUInteger                   _hash;
   _MulleObjCKVCKeybasedCache   *_cache;
};


@interface _MulleObjCKVCCache : NSObject 
{
   NSHashTable   *_table;
}
 
+ (id) cache;

   // Objective-C interface
- (id) valueForObject:(id) obj
                  key:(NSString *) key;

- (id) valueForObject:(id) obj
              keyPath:(NSString *) path;

@end

// C Interface
_MulleObjCKVCCache   *_MulleObjCKVCCreateCache( void);

void _MulleObjCKVCCacheFree( _MulleObjCKVCCache *self);
id   _MulleObjCKVCCacheValueForObjectAndKey( _MulleObjCKVCCache *self, id obj, NSString *key);
id   _MulleObjCKVCCacheValueForObjectAndKeyPath( _MulleObjCKVCCache *self, id obj, NSString *path);

