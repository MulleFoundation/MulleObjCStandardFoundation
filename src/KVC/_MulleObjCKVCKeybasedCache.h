/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCKVCKeybasedCache.h,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "_MulleObjCKVCInformation.h"


struct _MulleObjCKVCKeybasedCacheline
{
   Class                             aClass;
   struct _MulleObjCKVCInformation   info;
};


enum
{
   _MulleObjCKVCSmallKeybasedCacheSize  = 16, // not prime
   _MulleObjCKVCMediumKeybasedCacheSize = 64,
   _MulleObjCKVCLargeKeybasedCacheSize  = 512
};


// don't subclass this ...
@interface _MulleObjCKVCKeybasedCache : NSObject 
{
   unsigned int   _mask;
   NSString       *_key;
   
   
@private
   struct _MulleObjCKVCKeybasedCacheline   *_lastLine;
   Class                                    _lastClass;
   struct _MulleObjCKVCKeybasedCacheline   _cacheLines[ 1];
}


+ (id) cacheWithSize:(unsigned int) size
              forKey:(NSString *) key;

// Objective-C interface
- (id) valueForObject:(id) obj;

@end

// C Interface
_MulleObjCKVCKeybasedCache   *_MulleObjCKVCKeybasedCacheCreateWithKey( unsigned int size, NSString *key);

void   __MulleObjCKVCKeybasedCacheFree( _MulleObjCKVCKeybasedCache *self);
id     _MulleObjCKVCKeybasedCacheValueForObject( _MulleObjCKVCKeybasedCache *self, id obj);
