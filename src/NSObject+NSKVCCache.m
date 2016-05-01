/*
 *  _NSEOFoundation - Base Functionality of _NSEOF (Project Titmouse) 
 *                      Part of the _NS EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _NS kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCCache.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "NSObject+NSKVCCache.h"

#import "_MulleObjCKeyValueCodingFoundation.h"


@implementation NSObject ( _NSKVCCache)

//
// place here, because we need it in Foundation and I don't want to make a
// new file for it
//
+ (BOOL) useInstanceCreationWithSnapshotSetter
{
   return( NO);
}


- (id) valueForKey:(NSString *) key
        usingCache:(_NSKVCCache *) cache
{
   return( _NSKVCCacheValueForObjectAndKey( cache, self, key));
}


//
// this is a little bit different, than Foundation
// which is recursive...
//
- (id) valueForKeyPath:(NSString *) path
            usingCache:(_NSKVCCache *) cache;  // interesting
{
   NSArray        *components;
   unsigned int   i, n;
   id             value;
   id             *buf;
   
   components = [path componentsSeparatedByString:@"."];
   
   n = [components count];
#ifndef DEBUG   // go through the pain to find bugs 
   if( n == 1)
      return( _NSKVCCacheValueForObjectAndKey( cache, self, path));
#endif   
   buf = (id *) _NSSafeAlloca( sizeof( id) * n);
   [components getObjects:buf];
   
   value = self;
   for( i = 0; i < n; i++)
      value = _NSKVCCacheValueForObjectAndKey( cache, value, buf[ i]);

   return( value);
}


@end
