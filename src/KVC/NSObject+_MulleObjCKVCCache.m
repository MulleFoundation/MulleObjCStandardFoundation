/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: NSObject+NSKVCCache.m,v b9a3127cf1df 2010/08/11 16:35:38 nat $
 *
 *  $Log$
 */
#import "NSObject+_MulleObjCKVCCache.h"

// other files in this library
#import "_MulleObjCKVCCache.h"
#import "NSString+Components.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"

// std-c and other dependencies
#include <alloca.h>


#if DEBUG  // coz the stupid debugger trips up on alloca stack frames
# define mulle_safer_alloca( size)  ((void *) [[NSMutableData dataWithLength:size] mutableBytes])
#else
# define mulle_safer_alloca( size)  \
(size <= 0x400 ? alloca( size): (void *) [[NSMutableData dataWithLength:size] mutableBytes])
#endif



@implementation NSObject ( _MulleObjCKVCCache)

//
// place here, because we need it in Foundation and I don't want to make a
// new file for it
//
+ (BOOL) useInstanceCreationWithSnapshotSetter
{
   return( NO);
}


- (id) valueForKey:(NSString *) key
        usingCache:(_MulleObjCKVCCache *) cache
{
   return( _MulleObjCKVCCacheValueForObjectAndKey( cache, self, key));
}


//
// this is a little bit different, than Foundation
// which is recursive...
//
- (id) valueForKeyPath:(NSString *) path
            usingCache:(_MulleObjCKVCCache *) cache;  // interesting
{
   NSArray      *components;
   NSUInteger   i, n;
   id           value;
   id           *buf;
   
   components = [path componentsSeparatedByString:@"."];
   
   n = [components count];
#ifndef DEBUG   // go through the pain to find bugs 
   if( n == 1)
      return( _MulleObjCKVCCacheValueForObjectAndKey( cache, self, path));
#endif   
   buf = (id *) mulle_safer_alloca( sizeof( id) * n);
   [components getObjects:buf];
   
   value = self;
   for( i = 0; i < n; i++)
      value = _MulleObjCKVCCacheValueForObjectAndKey( cache, value, buf[ i]);

   return( value);
}


@end
