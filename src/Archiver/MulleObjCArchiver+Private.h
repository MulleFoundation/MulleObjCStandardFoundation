//
//  NSArchiver+Private.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 18.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSArchiver.h"

#import "MulleObjCFoundationString.h"

//
// this is all static inline to share code w/o littering the namespace
// between NSArchiver and NSUnarchiver

struct blob
{
   size_t   _length;
   void     *_storage;
};


static inline  uintptr_t   blob_hash( struct mulle_container_keycallback *ignore,
                                      struct blob *blob)
{
   NSUInteger   len;
   
   len = blob->_length;
   if( len > 256)
      len = 256;
   return( mulle_hash( blob->_storage, len));
}


static inline int   blob_is_equal( struct mulle_container_keycallback *ignore,
                                   struct blob  *a,
                                   struct blob  *b)
{
   assert( a && b);
   if( a->_length != b->_length)
      return( 0);
   return( ! memcmp( a->_storage, b->_storage, a->_length));
}


static inline void   *blob_describe( struct mulle_container_keycallback *ignore,
                                     struct blob  *blob,
                                     struct mulle_allocator *allocator)
{
   return( [NSString stringWithFormat:@"<%ld %p %.*s>",
            blob->_length, blob->_storage,
            blob->_length, blob->_storage]);
}



#pragma mark -
#pragma mark MulleObjCPointerHandleMap



static inline void   MulleObjCPointerHandleMapInit( struct MulleObjCPointerHandleMap *map,
                                                   unsigned int capacity,
                                                   struct mulle_container_keyvaluecallback *callback,
                                                   struct mulle_allocator *allocator)
{
   mulle_map_init( &map->map, capacity, callback, allocator);
   mulle_pointerarray_init( &map->array, capacity, NULL, allocator);
}


static inline void   MulleObjCPointerHandleMapDone( struct MulleObjCPointerHandleMap *map)
{
   mulle_map_done( &map->map);
   mulle_pointerarray_done( &map->array);
}


static inline intptr_t  MulleObjCPointerHandleMapGet( struct MulleObjCPointerHandleMap *map,
                                                      void *p)
{
   intptr_t   handle;
   
   handle = (intptr_t) mulle_map_get( &map->map, p);
   if( handle)
      return( handle);
   
   handle      = mulle_map_get_count( &map->map) + 1;
   mulle_map_set( &map->map, p, (void *) handle);
   mulle_pointerarray_add( &map->array,p);
   
   return( handle);
}
