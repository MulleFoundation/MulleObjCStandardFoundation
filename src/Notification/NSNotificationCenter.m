/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNotificationCenter.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNotificationCenter.h"

// other files in this library
#import "NSNotification.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies
#import <mulle_container/mulle_container.h>


// notes an observer can be registered for the same method twice
// with same selector and everything
   
/*
digraph maptables
{
   node [shape=box];

   _pairRegistry [ shape=folder, style="bold"];
   _entry [ style="dotted"];
   _pairRegistry -> _entry;
   _pairRegistry -> _entry;
   _pairRegistry -> _entry;
   _entry -> _pair [label="key (owns)", color="darkgreen", fontcolor="darkgreen"];
   _entry -> _tripletQueue [label="value (owns)", color="blue", fontcolor="blue"];

   _pairQueue [ label="queue"];
   _pairQueue -> _pair;
   _pairQueue -> _pair;
   _pairQueue -> _pair;
   _pair -> _sender           [ arrowhead="none"];
   _pair -> _notificationName [ arrowhead="none"];

   _tripletQueue [ label="queue"];
   _tripletQueue -> _triplet;
   _tripletQueue -> _triplet;
   _tripletQueue -> _triplet;
   _triplet -> _observer [arrowhead="none"];
   _triplet -> _selector [arrowhead="none"]];
   _triplet -> _imp      [arrowhead="none"]];

   _observerRegistry [ shape=folder,  style="bold"];
   _entry2 [ style="dotted", label="_entry"];
   _observerRegistry -> _entry2;
   _observerRegistry -> _entry2;
   _observerRegistry -> _entry2;
   _entry2 -> _observer [label="key (ref)", color="brown", fontcolor="brown"];
   _entry2 -> _pairQueue [label="value (ref)", color="purple", fontcolor="purple"];
}
*/
typedef struct
{
   NSString   *name;           
   id         sender;    
} name_sender_pair;


typedef struct
{
   id         observer;
   SEL        sel;
   IMP        imp;
} observer_sel_imp_triplet;


static inline name_sender_pair   *pair_copy( name_sender_pair *pair,
                                             struct mulle_allocator *allocator)
{
   name_sender_pair  *duplicate;
   
   duplicate  = mulle_allocator_malloc( allocator, sizeof( name_sender_pair));
   *duplicate = *pair;
   return( duplicate);
}


static inline observer_sel_imp_triplet   *triplet_copy( observer_sel_imp_triplet *triplet,
                                                        struct mulle_allocator *allocator)
{
   observer_sel_imp_triplet  *duplicate;
   
   duplicate  = mulle_allocator_malloc( allocator, sizeof( observer_sel_imp_triplet));
   *duplicate = *triplet;
   return( duplicate);
}



/* 
   An observer (a) is registered for a 'name and sender' (pair), either
   of which can be nil. Sender and object is the same here...

        a
      n   s
   -----+-----
      0   0    // match any notification
      0   1    // match all notifications of object
      1   0    // match all notifications with that name
      1   1    // match all notifications of object with that name

   A notification (b) always has a name, but may not have an 
   object

        b   
      n   s
   -----+-----
      1   0    // name, no object 
      1   1    // name and object
      
   so there are eight possibilities
   
   
    notif.   observ.
       b   |   a
     n   s | n   s      
   ----+---+---+---    
     1   0   0   0     a) true
     1   1   0   0     b) true
     1   0   0   1     c) false
     1   1   0   1     d) b.s == a.s
     1   0   1   0     e) b.n == a.n
     1   1   1   0     f) b.n == a.n
     1   0   1   1     g) false
     1   1   1   1     h) b.n == a.n && b.s == b.s
     
*/

static NSUInteger   pair_hash( struct mulle_container_keycallback *table,
                               name_sender_pair *pair)
{
   NSUInteger  hash;
   
   hash = (intptr_t) pair->sender << 10;
   hash += [pair->name hash];
   return( hash);
}


static BOOL   pair_is_equal( struct mulle_container_keycallback *table,
                             name_sender_pair *a, name_sender_pair *b)
{
   if( a->sender != b->sender)      
      return( NO);
   return( a->name == b->name || [b->name isEqualToString:a->name]); 
}


static NSString   *describe_pair( struct mulle_container_keycallback *table,
                                  name_sender_pair *a,
                                  struct mulle_allocator *allocator)
{
   return( @"");
}


static void    free_queue( struct mulle_container_keycallback *table,
                           struct _mulle_queue *a,
                           struct mulle_allocator *allocator)
{
   _mulle_queue_free( a, allocator);
}


static NSString   *describe_queue( struct mulle_container_keycallback *table,
                                   struct _mulle_queue *a,
                                   struct mulle_allocator *allocator)
{
   return( @"");
}


static void    free_queue_and_contents( struct mulle_container_keycallback *table,
                                        struct _mulle_queue *queue,
                                        struct mulle_allocator *allocator)
{
   struct _mulle_queueenumerator   rover;
   void                           *value;

   rover = _mulle_queue_enumerate( queue);
   while( value = _mulle_queueenumerator_next( queue, &rover))
      mulle_allocator_free( allocator, value);
   _mulle_queueenumerator_done( &rover);
   
   _mulle_queue_free( queue, allocator);
}




//   (unsigned (*)(struct mulle_container_keycallback *table, const void *)) hash,
//   (BOOL (*)(struct mulle_container_keycallback *table, const void *, const void  *)) isEqual,
//   NULL,
//   NULL,
//   NSString *(*)(struct mulle_container_keycallback *table, const void *) describe

static struct mulle_container_keyvaluecallback    pair_registry_callbacks =
{
   {
      (void *) pair_hash,
      (void *) pair_is_equal,
      (void *) mulle_container_callback_self,
      (void *) mulle_container_callback_nop,
      (void *) describe_pair,
      NULL,
      NULL
   },
   {
      (void *) mulle_container_callback_self,
      (void *) free_queue,
      (void *) describe_queue,
      NULL
   }
};


static struct mulle_container_keyvaluecallback    sender_registry_callbacks =
{
   {
      (void *) mulle_container_callback_pointer_hash,
      (void *) mulle_container_callback_pointer_is_equal,
      (void *) mulle_container_callback_self,
      (void *) mulle_container_callback_nop,
      (void *) mulle_container_callback_no_value,
      NULL,
      NULL
   },
   {
      (void *) mulle_container_callback_self,
      (void *) free_queue,
      (void *) describe_queue,
      NULL
   }
};


#define name_registry_callbacks       sender_registry_callbacks
#define observer_registry_callbacks   sender_registry_callbacks


static struct mulle_container_keyvaluecallback    observer_no_free_registry_callbacks =
{
   {  
      (void *) mulle_container_callback_pointer_hash,
      (void *) mulle_container_callback_pointer_is_equal,
      (void *) mulle_container_callback_self,
      (void *) mulle_container_callback_nop,
      (void *) mulle_container_callback_no_value,
      NULL,
      NULL
   },
   {  
      (void *) mulle_container_callback_self,
      (void *) mulle_container_callback_nop,
      (void *) describe_queue,
      NULL
   }
};



@implementation NSNotificationCenter

// the address of this variable (is the stand in for the n=0 s=0 observer)
// stored in the sender registry 
static void      *OmniscientObserver;

- (id) init
{
   struct mulle_allocator   *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);

   mulle_map_init( &_pairRegistry, 128, &pair_registry_callbacks, allocator);
   mulle_map_init( &_observerRegistry, 64, &observer_registry_callbacks, allocator);
   mulle_map_init( &_nameRegistry, 5, &name_registry_callbacks, allocator);
   mulle_map_init( &_senderRegistry,5, &sender_registry_callbacks, allocator);
      
   return( self);
}


- (void) dealloc
{
   struct mulle_container_keyvaluecallback    callbacks;
   struct mulle_allocator                     *allocator;
   
   allocator = MulleObjCObjectGetAllocator( self);

   callbacks = sender_registry_callbacks;
   callbacks.valuecallback.release = (void *) free_queue_and_contents;
   _mulle_map_done( (struct _mulle_map *) &_senderRegistry, &callbacks, allocator);

   callbacks = name_registry_callbacks;
   callbacks.valuecallback.release = (void *) free_queue_and_contents;
   _mulle_map_done( (struct _mulle_map *) &_nameRegistry, &callbacks, allocator);

   callbacks = pair_registry_callbacks;
   callbacks.valuecallback.release = (void *) free_queue_and_contents;
   _mulle_map_done( (struct _mulle_map *) &_pairRegistry, &callbacks, allocator);

   // this one last
   callbacks = observer_registry_callbacks;
   callbacks.valuecallback.release = (void *) free_queue_and_contents;
   _mulle_map_done( (struct _mulle_map *) &_observerRegistry, &callbacks, allocator);
   
   [super dealloc];
}


+ (id) defaultCenter
{
   static NSNotificationCenter  *defaultCenter;
   
   if( ! defaultCenter)
      defaultCenter = [self new];
   return( defaultCenter);
}


static void   NSNotificationCenterPostNotificationNotifyReceivers( struct _mulle_queue *queue,
                                                                   NSNotification *notification)
{
   struct _mulle_queueenumerator   rover;
   observer_sel_imp_triplet        *p;
   observer_sel_imp_triplet        *sentinel;
   observer_sel_imp_triplet        *buf;
   observer_sel_imp_triplet        *tofree;
   NSUInteger                      i, n;
   size_t                          size;
   
   tofree = NULL;

   //
   // need to copy, to allow modifications
   //
   n    = _mulle_queue_get_count( queue);
   size = n * sizeof( observer_sel_imp_triplet);
   if( n < 64)
      buf = alloca( size);
   else
     tofree = buf = MulleObjCAllocateNonZeroedMemory( size);

   i = 0;
   rover = _mulle_queue_enumerate( queue);
   while( p = _mulle_queueenumerator_next( queue, &rover))
   {
      buf[ i] = *p;
      NSAutoreleaseObject( [buf[ i].observer retain]);
      ++i;
   }
   _mulle_queueenumerator_done( &rover);

   //
   // if it's really a problem, that messages are sent after a receiver
   // has removed himself (within the same posting cycle) put a 
   // log on the center to track removals and check with that in this loop
   // preference: document and keep it like this
   //
   p        = buf;
   sentinel = &p[ n];
   while( p < sentinel)
   {
      (*p->imp)( p->observer, p->sel, notification);
      ++p;
   }
   
   MulleObjCDeallocateMemory( tofree);
}


static void   post_pair( NSNotificationCenter *self, name_sender_pair *pair, NSNotification *notification)
{
   struct _mulle_queue   *queue;
   
   queue = mulle_map_get( &self->_pairRegistry, pair);
   if( queue)
      NSNotificationCenterPostNotificationNotifyReceivers( queue, notification);
}


static void   post_name( NSNotificationCenter *self, NSString *name, NSNotification *notification)
{
   struct _mulle_queue   *queue;
   
   queue = mulle_map_get( &self->_nameRegistry, name);
   if( queue)
      NSNotificationCenterPostNotificationNotifyReceivers( queue, notification);
}


static void   post_sender( NSNotificationCenter *self, id sender, NSNotification *notification)
{
   struct _mulle_queue   *queue;
   
   queue = mulle_map_get( &self->_senderRegistry, sender);
   if( queue)
      NSNotificationCenterPostNotificationNotifyReceivers( queue, notification);
}


  
static void   NSNotificationCenterPostNotification( NSNotificationCenter  *self, 
                                                    NSNotification *notification)
{
   name_sender_pair   pair;

   pair.name   = [notification name];
   pair.sender = [notification object];
   
   if( pair.sender)
   {
      post_pair( self, &pair, notification);
      post_sender( self, pair.sender, notification);
   }
   
   post_name( self, pair.name, notification);
   post_sender( self, (void *) &OmniscientObserver, notification);
}


- (void) postNotification:(NSNotification *) notification
{
   NSNotificationCenterPostNotification( self, notification);
}


- (void) postNotificationName:(NSString *) name 
                       object:(id) sender
{
   NSNotification  *notification;
   
   notification = [NSNotification notificationWithName:name
                                                object:sender];
   NSNotificationCenterPostNotification( self, notification);
}                     


- (void) postNotificationName:(NSString *) name 
                       object:(id) sender 
                     userInfo:(NSDictionary *) userInfo
{
   NSNotification  *notification;
   
   notification = [NSNotification notificationWithName:name
                                                object:sender
                                              userInfo:userInfo];
   NSNotificationCenterPostNotification( self, notification);
}                     


static void  add_triplet_for_key( struct mulle_map *table, 
                                  void *key,
                                  observer_sel_imp_triplet *triplet)
{
   struct _mulle_queue       *triplet_queue;
   struct mulle_allocator   *allocator;
   
   triplet_queue = mulle_map_get( table, key);
   allocator     = mulle_map_get_allocator( table);
   
   if( ! triplet_queue)
   {      
      triplet_queue = _mulle_queue_create( 2, 0, allocator);  // spare allowance MUST be zero
      mulle_map_insert( table, key, triplet_queue);
   }
   _mulle_queue_push( triplet_queue, triplet, &mulle_container_keycallback_nonowned_pointer, allocator);
}
   
                       
- (void) addObserver:(id) observer 
            selector:(SEL) sel 
                name:(NSString *) name 
              object:(id) sender
{
   name_sender_pair          *pair;
   name_sender_pair          key;
   observer_sel_imp_triplet  *triplet;
   observer_sel_imp_triplet  value;
   struct _mulle_queue        *pair_queue;
   struct mulle_allocator   *allocator;
   
   allocator      = mulle_map_get_allocator( &self->_nameRegistry);
   
   value.observer = observer;
   value.sel      = sel;
   value.imp      = [observer methodForSelector:sel];

   triplet = triplet_copy( &value, allocator);

   key.name   = name;
   key.sender = sender;
   pair       = pair_copy( &key, allocator);

   /* these own the triplet */
   if( ! name)
   {
      if( ! sender)
         sender = (void *) &OmniscientObserver;
      add_triplet_for_key( &_senderRegistry, sender, triplet);
   }
   else
      if( ! sender)
         add_triplet_for_key( &_nameRegistry, name, triplet);
      else
         add_triplet_for_key( &_pairRegistry, pair, triplet);

   /* this owns the pair */
   pair_queue = mulle_map_get( &_observerRegistry, observer);
   if( ! pair_queue)
   {      
      pair_queue = _mulle_queue_create( 2, 0, allocator);  // spare allowance MUST be zero
      mulle_map_insert( &_observerRegistry, observer, pair_queue);
   }
   _mulle_queue_push( pair_queue, pair, &mulle_container_keycallback_nonowned_pointer, allocator);
}


static struct _mulle_queue   *tripletQueueByRemovingObserver( struct _mulle_queue *triplet_queue,
      id observer,
      struct mulle_allocator *allocator)
{
   struct _mulle_queueenumerator   rover;
   observer_sel_imp_triplet        *triplet;
   struct _mulle_queue              *cleaned;
   BOOL                            hit;

   hit     = NO;
   cleaned = NULL;
   
   rover = _mulle_queue_enumerate( triplet_queue);
   while( triplet = _mulle_queueenumerator_next( triplet_queue, &rover))
   {
      if( triplet->observer == observer)
      {
         hit = YES;
         mulle_allocator_free( allocator, triplet);
         continue;
      }
      
      if( ! cleaned)
         cleaned = _mulle_queue_create( _mulle_queue_get_bucketsize( triplet_queue), 0, allocator);
      _mulle_queue_push( cleaned, triplet, &mulle_container_keycallback_nonowned_pointer, allocator);
   }
   _mulle_queueenumerator_done( &rover);

   if( ! cleaned && ! hit)
   {
#if DEBUG
      abort();
#endif      
      return( triplet_queue); // does this ever happen ?
   }
   
   return( cleaned);
}


static void    dequeueObserverForKey( struct mulle_map *table,
                                      void *key,
                                      void *observer,
                                      struct mulle_allocator *allocator)
{
   struct _mulle_queue   *triplet_queue;
   struct _mulle_queue   *cleaned_triplet_queue;

   triplet_queue = mulle_map_get( table, key);

   cleaned_triplet_queue = tripletQueueByRemovingObserver( triplet_queue, observer, allocator);
   if( ! cleaned_triplet_queue)
   {
      mulle_map_remove( table, key);
      return;
   }

   // a pointer queue, doesn't free its contents
   if( cleaned_triplet_queue != triplet_queue)
      mulle_map_insert( table, key, cleaned_triplet_queue);
}


static void   removeObserverForPairAndDeallocate( NSNotificationCenter *self, name_sender_pair *pair, id observer, struct mulle_allocator *allocator)
{
   if( ! pair->name)
   {
      dequeueObserverForKey( &self->_senderRegistry, 
                             pair->sender ? pair->sender : (void *) &OmniscientObserver,
                             observer,
                             allocator);
   }
   else
      if( ! pair->sender)
         dequeueObserverForKey( &self->_nameRegistry, pair->name, observer, allocator);
      else
         dequeueObserverForKey( &self->_pairRegistry, pair, observer, allocator);
   
   mulle_allocator_free( allocator, pair);
}


- (void) removeObserver:(id) observer
{
   struct _mulle_queueenumerator   rover;
   struct _mulle_queue             *pair_queue;
   struct mulle_allocator          *allocator;
   name_sender_pair                *pair;
   
   pair_queue = mulle_map_get( &_observerRegistry, observer);
   if( ! pair_queue)
      return;
   
   allocator = mulle_map_get_allocator( &_observerRegistry);
   
   _mulle_map_remove( (struct _mulle_map *) &_observerRegistry, observer, &observer_no_free_registry_callbacks, allocator);
   
   rover = _mulle_queue_enumerate( pair_queue);
   while( pair = _mulle_queueenumerator_next( pair_queue, &rover))
   {
      removeObserverForPairAndDeallocate( self, pair, observer, allocator);
   }
   _mulle_queueenumerator_done( &rover);

   _mulle_queue_free( pair_queue, allocator);
}


- (void) removeObserver:(id) observer 
                   name:(NSString *) name 
                 object:(id) sender
{
   struct _mulle_queueenumerator   rover;
   struct _mulle_queue             *pair_queue;
   struct _mulle_queue             *new_queue;
   struct mulle_allocator          *allocator;
   name_sender_pair                *pair;
   
   pair_queue = mulle_map_get( &_observerRegistry, observer);
   if( ! pair_queue)
      return;
   
   allocator = mulle_map_get_allocator( &self->_observerRegistry);
   new_queue = _mulle_queue_create( _mulle_queue_get_bucketsize( pair_queue), 0, allocator);
   
   rover = _mulle_queue_enumerate( pair_queue);
   while( pair = _mulle_queueenumerator_next( pair_queue, &rover))
   {
      if( (sender && sender != pair->sender) ||
          (name && ! (name == pair->name || [name isEqualToString:pair->name])))
      {
         _mulle_queue_push( new_queue, pair, &mulle_container_keycallback_nonowned_pointer, allocator);
         continue;
      }
      
      removeObserverForPairAndDeallocate( self, pair, observer, allocator);
   }
   _mulle_queueenumerator_done( &rover);

   // reap old one
   mulle_map_remove( &_observerRegistry, observer);
   if( ! _mulle_queue_get_count( new_queue))
      mulle_map_insert( &_observerRegistry, observer, new_queue);
}

@end

