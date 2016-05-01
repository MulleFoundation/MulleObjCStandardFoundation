/*
 *  _MulleObjCEOFoundation - Base Functionality of _MulleObjCEOF (Project Titmouse) 
 *                      Part of the _MulleObjC EOControl Framework Collection
 *  Copyright (C) 2006 Nat!, Codeon GmbH, _MulleObjC kybernetiK. All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id: _MulleObjCKVCCache.m,v 8dd43f91c8c4 2010/11/22 12:55:32 nat $
 *
 *  $Log$
 */
#import "_MulleObjCKVCCache.h"

// other files in this library
#import "_MulleObjCKVCKeybasedCache.h"
#import "NSString+Components.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and other dependencies



#if DEBUG  // coz the stupid debugger trips up on alloca stack frames
# define mulle_safer_alloca( size)  ((void *) [[NSMutableData dataWithLength:size] mutableBytes])
#else
# define mulle_safer_alloca( size)  \
(size <= 0x400 ? alloca( size): (void *) [[NSMutableData dataWithLength:size] mutableBytes])
#endif


@implementation _MulleObjCKVCCache

static BOOL  _MulleObjCKVCCachelineIsEqual( NSHashTable *table, struct _MulleObjCKVCCacheline *p, struct _MulleObjCKVCCacheline *q)
{
   return( [p->_key isEqualToString:q->_key]);
}


static void   _MulleObjCKVCCachelineFree( NSHashTable *table, struct _MulleObjCKVCCacheline *p)
{
   [p->_key release];
   __MulleObjCKVCKeybasedCacheFree( p->_cache);
   NSZoneFree( NULL, p);
}


id   _MulleObjCKVCCacheValueForObjectAndKey( _MulleObjCKVCCache *self, id obj, NSString *key)
{
   struct _MulleObjCKVCCacheline   *p;
   struct _MulleObjCKVCCacheline   search;
   
   if( ! obj)
      return( nil);
   
   NSCParameterAssert( key);
   
   search._key  = key;
   search._hash = [key hash];
   
   p = NSHashGet( self->_table, &search);
   if( ! p)
   {
      p = NSZoneMalloc( NULL, sizeof( struct _MulleObjCKVCCacheline));

      p->_key   = [key copy];
      p->_hash  = [p->_key hash];
      p->_cache = _MulleObjCKVCKeybasedCacheCreateWithKey( _MulleObjCKVCSmallKeybasedCacheSize, p->_key);
      
      NSHashInsertKnownAbsent( self->_table, p);
   }
   
   return( _MulleObjCKVCKeybasedCacheValueForObject( p->_cache, obj));
}


- (id) valueForObject:(id) obj
                  key:(NSString *) key
{
   return( _MulleObjCKVCCacheValueForObjectAndKey( self, obj, key));
}


id   _MulleObjCKVCCacheValueForObjectAndKeyPath( _MulleObjCKVCCache *self, id obj, NSString *path)
{
   NSArray        *components;
   NSUInteger     i, n;
   id             value;
   id             *buf;
   
   components = [path componentsSeparatedByString:@"."];
   if( ! components)
      return( _MulleObjCKVCCacheValueForObjectAndKey( self, obj, path));
      
   value = obj;
   n    = [components count];
   if( n > 2)  // assumption...
   {
      buf = (id *) mulle_safer_alloca( sizeof( id) * n);
      [components getObjects:buf];
   
      for( i = 0; i < n; i++)
         value = _MulleObjCKVCCacheValueForObjectAndKey( self, value, buf[ i]);
   }
   else
      for( i = 0; i < n; i++)
         value = _MulleObjCKVCCacheValueForObjectAndKey( self, value, [components objectAtIndex:i]);
   
   return( value);
}


- (id) valueForObject:(id) obj
              keyPath:(NSString *) key
{
   return( _MulleObjCKVCCacheValueForObjectAndKeyPath( self, obj, key));
}


static _MulleObjCKVCCache   *__MulleObjCKVCCreateCache( Class aClass)
{
   _MulleObjCKVCCache     *cache;
   NSHashTableCallBacks   callbacks;
   
   cache             = NSAllocateObject( aClass, 0, NULL);
#if DEBUG_VERBOSE
   fprintf( stderr, ">>>>>>>> 0x%llX lives\n", (long long) cache);
#endif   
   callbacks         = NSOwnedPointerHashCallBacks;
   callbacks.is_equal = (void *) _MulleObjCKVCCachelineIsEqual;
   callbacks.release = (void *) _MulleObjCKVCCachelineFree;

   cache->_table     = NSCreateHashTable( callbacks, 63);

   return( cache);
}


_MulleObjCKVCCache   *_MulleObjCKVCCreateCache( void)
{
   return( __MulleObjCKVCCreateCache( [_MulleObjCKVCCache class]));
}


void   _MulleObjCKVCCacheFree( _MulleObjCKVCCache *self)
{
   NSFreeHashTable( self->_table);
#if DEBUG_VERBOSE
   fprintf( stderr, ">>>>>>>> 0x%llX dies\n", (long long) self);
#endif   
   NSDeallocateObject( self);
}


+ (id) cache
{
   _MulleObjCKVCCache   *cache;
   
   cache = __MulleObjCKVCCreateCache( self);
   return( [cache autorelease]);
}


- (void) dealloc
{
   _MulleObjCKVCCacheFree( self);
}


/* you don't do much with the cache ... */
#if DEBUG   

+ (id) allocWithZone:(NSZone *) zone
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
