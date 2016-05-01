/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCKVCKeybasedCache.m,v 8dd43f91c8c4 2010/11/22 12:55:32 nat $
 *
 *  $Log$
 */
#import "_MulleObjCKVCKeybasedCache.h"

// other files in this library
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "_MulleObjCKVCInformation.h"
#import "NSObject+_MulleObjCKVCInformation.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCBaseFunctions.h"

// std-c and dependencies

@implementation _MulleObjCKVCKeybasedCache



id   _MulleObjCKVCKeybasedCacheValueForObject( _MulleObjCKVCKeybasedCache *self, id obj)
{
   Class                                   aClass;
   Class                                   cachedClass;
   struct _MulleObjCKVCInformation         *cachedInfo;
   struct _MulleObjCKVCKeybasedCacheline   *p;
   unsigned int                            i;
   
   //
   // because of partial faults, we don't want to fire the fault
   // needlessly... so we can't cache it (yet)
   //
   NSCParameterAssert( self);
 
   if( ! obj)
      return( nil);
   
//   if( _MulleObjCEOIsFault( obj))  // fault check slows this down ??
//      return( [obj valueForKey:self->_key]);  

   aClass = [obj class];
   if( aClass == self->_lastClass)
      p = self->_lastLine;
   else
   {
      i = (unsigned int) mulle_hash_pointer( aClass) & self->_mask;
      p = &self->_cacheLines[ i];
      
      self->_lastClass = aClass;
      self->_lastLine  = p;
   }
   
   cachedClass  = p->aClass;
   cachedInfo   = &p->info;
   
   if( cachedClass != aClass)
   {
      p->aClass = aClass;
      _MulleObjCClearKVCInformation( cachedInfo);
      [aClass _divineValueForKeyKVCInformation:cachedInfo
                                          key:self->_key];
   }
   
   return( _MulleObjCGetObjectValueWithKVCInformation( obj, cachedInfo));
}


- (id) valueForObject:(id) obj
{
   return( _MulleObjCKVCKeybasedCacheValueForObject( self, obj));
}


/*##
 ###
 ##*/
static _MulleObjCKVCKeybasedCache   *__MulleObjCKVCKeybasedCacheCreateWithKey( Class aClass, unsigned int size, NSString *key)
{
   _MulleObjCKVCKeybasedCache   *cache;
   
   NSCParameterAssert( size);  // must be prime and > 0 (we check for oddness:)

   cache        = NSAllocateObject( aClass, (size - 1) * sizeof( struct _MulleObjCKVCKeybasedCacheline), NULL);
#if DEBUG_VERBOSE
   fprintf( stderr, ">>>>>>>> 0x%llX lives\n", (long long) cache);
#endif   
   cache->_mask = size - 1 ;
   cache->_key  = [key copy];

   return( cache);
}


_MulleObjCKVCKeybasedCache   *_MulleObjCKVCKeybasedCacheCreateWithKey( unsigned int size, NSString *key)
{
   return( __MulleObjCKVCKeybasedCacheCreateWithKey( [_MulleObjCKVCKeybasedCache class], size, key));
}


void   __MulleObjCKVCKeybasedCacheFree( _MulleObjCKVCKeybasedCache *self)
{
   unsigned int                            i;
   struct _MulleObjCKVCKeybasedCacheline   *p;
   
   p = self->_cacheLines;
   for( i = 0; i <= self->_mask; i++)
   {
      _MulleObjCClearKVCInformation( &p->info);
      p++;
   }
   [self->_key release];
   
   NSDeallocateObject( self);
   
#if DEBUG_VERBOSE
   fprintf( stderr, ">>>>>>>> 0x%llX died\n", (long long) self);
#endif   
}


+ (id) cacheWithSize:(unsigned int) size
              forKey:(NSString *) key
{
   _MulleObjCKVCKeybasedCache   *cache;
   
   cache = __MulleObjCKVCKeybasedCacheCreateWithKey( self, size, key);
   return( [cache autorelease]);
}


- (void) dealloc
{
   __MulleObjCKVCKeybasedCacheFree( self);
}


#if DEBUG   
/* you don't do much with the cache ... */
+ (id) alloc
{
   abort();
   return( nil);
}


- (id) init
{
   abort();
   return( nil);
}
#endif   

@end
