//
//  NSNotificationCenter.m
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//
#pragma clang diagnostic ignored "-Wparentheses"

#import "NSNotificationCenter.h"

// other files in this library
#import "NSNotification.h"

// other libraries of MulleObjCStandardFoundation
#import "MulleObjCStandardValueFoundation.h"
#import "MulleObjCStandardExceptionFoundation.h"

// std-c and dependencies
#import <mulle-container/mulle-container.h>

#include <stddef.h>


#ifdef DEBUG
# define QUEUE_BUCKETSIZE  2
#else
# define QUEUE_BUCKETSIZE  16
#endif


NSString   *MulleObjCUniverseWillFinalizeNotification =  @"MulleObjCUniverseWillFinalizeNotification";

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




static inline name_sender_pair   *pair_copy( void *callback,
                                             name_sender_pair *pair,
                                             struct mulle_allocator *allocator)
{
   name_sender_pair  *duplicate;

   duplicate  = mulle_allocator_malloc( allocator, sizeof( name_sender_pair));
   *duplicate = *pair;
   [duplicate->name retain];
   return( duplicate);
}


static inline void   pair_destroy( void *callback,
                                   name_sender_pair *pair,
                                   struct mulle_allocator *allocator)
{
   [pair->name autorelease];
   mulle_allocator_free( allocator, pair);
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

static uintptr_t   pair_hash( struct mulle_container_keycallback *table,
                              name_sender_pair *pair)
{
   NSUInteger  hash;

   hash  = (intptr_t) pair->sender << 10;
   hash += [pair->name hash];
   return( hash);
}


static int   pair_is_equal( struct mulle_container_keycallback *table,
                             name_sender_pair *a, name_sender_pair *b)
{
   if( a->sender != b->sender)
      return( NO);
   return( a->name == b->name || [b->name isEqualToString:a->name]);
}


static char   *object_describe( struct mulle_container_keycallback *table,
                                void *a,
                                struct mulle_allocator **p_allocator)
{
   *p_allocator = NULL;
   return( [[NSString stringWithFormat:@"%p", a] UTF8String]);
}


static char   *pair_describe( struct mulle_container_keycallback *table,
                              void *_a,
                              struct mulle_allocator **p_allocator)
{
   name_sender_pair *a = _a;

   *p_allocator = NULL;
   return( [[NSString stringWithFormat:@"@selector(%@)/%p", a->name, a->sender] UTF8String]);
}


static char   *pairqueue_describe( struct mulle_container_valuecallback *table,
                                   void *_queue,
                                   struct mulle_allocator **p_allocator)
{
   struct mulle__pointerqueue             *queue = _queue;
   name_sender_pair                       *p;
   NSMutableString                        *s;
   NSString                               *sep;
   struct mulle__pointerqueueenumerator   rover;

   *p_allocator = NULL;

   s   = [NSMutableString string];
   sep = @"";

   rover = mulle__pointerqueue_enumerate( queue);
   while( _mulle__pointerqueueenumerator_next( &rover, (void **) &p))
   {
      [s appendString:sep];
      sep = @", ";
      [s appendFormat:@"@selector(%@)/%p", p->name, p->sender];
   }
   mulle__pointerqueueenumerator_done( &rover);
   return( [s UTF8String]);
}


static char   *tripletqueue_describe( struct mulle_container_valuecallback *table,
                                      void *_queue,
                                      struct mulle_allocator **p_allocator)
{
   struct mulle__pointerqueue             *queue = _queue;
   observer_sel_imp_triplet               *p;
   NSMutableString                        *s;
   NSString                               *sep;
   struct mulle__pointerqueueenumerator   rover;

   *p_allocator = NULL;

   s   = [NSMutableString string];
   sep = @"";

   rover = mulle__pointerqueue_enumerate( queue);
   while( _mulle__pointerqueueenumerator_next( &rover, (void **) &p))
   {
      [s appendString:sep];
      sep = @", ";
      [s appendFormat:@"%p/@selector(%@)/%p", p->observer,
                                   NSStringFromSelector( p->sel),
                                   p->imp];
   }
   mulle__pointerqueueenumerator_done( &rover);
   return( [s UTF8String]);
}


static void    queue_destroy( struct mulle_container_keycallback *table,
                              struct mulle__pointerqueue *a,
                              struct mulle_allocator *allocator)
{
   _mulle__pointerqueue_destroy( a, allocator);
}


static void    free_queue_and_contents( struct mulle_container_keycallback *table,
                                        struct mulle__pointerqueue *queue,
                                        struct mulle_allocator *allocator)
{
   void   *value;

   while( value = _mulle__pointerqueue_pop( queue, allocator))
      mulle_allocator_free( allocator, value);
   _mulle__pointerqueue_destroy( queue, allocator);
}


//   (unsigned (*)(struct mulle_container_keycallback *table, const void *)) hash,
//   (BOOL (*)(struct mulle_container_keycallback *table, const void *, const void  *)) isEqual,
//   NULL,
//   NULL,
//   NSString *(*)(struct mulle_container_keycallback *table, const void *) describe

// key is a pair, value is a mulle_pointer_queue of triplets
static struct mulle_container_keyvaluecallback   pair_registry_callbacks =
{
   {
      (mulle_container_keycallback_hash_t *)      pair_hash,
      (mulle_container_keycallback_is_equal_t *)  pair_is_equal,
      (mulle_container_keycallback_retain_t *)    pair_copy,
      (mulle_container_keycallback_release_t *)   pair_destroy,
      pair_describe,
      NULL,
      NULL
   },
   {
      mulle_container_valuecallback_self,
      (void (*)()) queue_destroy,
      tripletqueue_describe,
      NULL
   }
};


// key is an object, value is a mulle_pointer_queue of triplets
static struct mulle_container_keyvaluecallback   sender_registry_callbacks =
{
   {
      mulle_container_keycallback_pointer_hash,
      mulle_container_keycallback_pointer_is_equal,
      mulle_container_keycallback_self,
      mulle_container_keycallback_nop,
      object_describe,
      NULL,
      NULL
   },
   {
      mulle_container_valuecallback_self,
      (void (*)()) queue_destroy,
      tripletqueue_describe,
      NULL
   }
};


// key is a string, value is a mulle_pointer_queue of triplets
static struct mulle_container_keyvaluecallback   name_registry_callbacks =
{
   {
      mulle_container_keycallback_object_hash,
      mulle_container_keycallback_object_is_equal,
      mulle_container_keycallback_self,
      mulle_container_keycallback_nop,
      object_describe,
      NULL,
      NULL
   },
   {
      mulle_container_valuecallback_self,
      (void (*)()) queue_destroy,
      tripletqueue_describe,
      NULL
   }
};


// key is an object, value is a mulle_pointer_queue of pairs!
static struct mulle_container_keyvaluecallback   observer_registry_callbacks =
{
   {
      mulle_container_keycallback_pointer_hash,
      mulle_container_keycallback_pointer_is_equal,
      mulle_container_keycallback_self,
      mulle_container_keycallback_nop,
      object_describe,
      NULL,
      NULL
   },
   {
      mulle_container_valuecallback_self,
      (void (*)()) queue_destroy,
      pairqueue_describe,
      NULL
   }
};


// same as sender_registry_callbacks, but doesn't free the queue
// key is an object, value is a mulle_pointer_queue of pairs!
static struct mulle_container_keyvaluecallback   observer_no_free_registry_callbacks =
{
   {
      mulle_container_keycallback_pointer_hash,
      mulle_container_keycallback_pointer_is_equal,
      mulle_container_keycallback_self,
      mulle_container_keycallback_nop,
      object_describe,
      NULL,
      NULL
   },
   {
      mulle_container_valuecallback_self,
      mulle_container_valuecallback_nop,
      pairqueue_describe,
      NULL
   }
};



@implementation NSNotificationCenter

// the address of this variable (is the stand in for the n=0 s=0 observer)
// stored in the sender registry
static struct
{
   void   *_OmniscientObserver; // unlocked
   BOOL   _isFinalizing;
} Self;


//
// called by the MulleObjC runtime, when the app exits with
// MULLE_OBJC_PEDANTIC_EXIT defined (or otherwise requested)
// We tell all our EOEditingContexts to finalize now
//
+ (void) willFinalize
{
   [[NSNotificationCenter defaultCenter] postNotificationName:MulleObjCUniverseWillFinalizeNotification
                                                       object:nil];

   Self._isFinalizing = YES; // now shutdown adding of observers (
}


- (instancetype) init
{
   struct mulle_allocator   *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);

   _mulle_map_init( &_observerRegistry, 64, &observer_registry_callbacks, allocator);
   _mulle_map_init( &_nameRegistry,      5, &name_registry_callbacks, allocator);
   _mulle_map_init( &_senderRegistry,    5, &sender_registry_callbacks, allocator);
   _mulle_map_init( &_pairRegistry,    128, &pair_registry_callbacks, allocator);

   if( mulle_thread_mutex_init( &_lock))
   {
      fprintf( stderr, "%s could not get a mutex\n", __FUNCTION__);
      abort();
   }

   return( self);
}


- (void) dealloc
{
   struct mulle_container_keyvaluecallback   callbacks;
   struct mulle_allocator                    *allocator;

   allocator = MulleObjCInstanceGetAllocator( self);

   // it's not easy to get the notification center to die after the observers
   // so this can give false positives
#if defined( DEBUG) & 0
   if( mulle_map_get_count( &_senderRegistry) ||
       mulle_map_get_count( &_nameRegistry)   ||
       mulle_map_get_count( &_pairRegistry)   ||
       mulle_map_get_count( &_observerRegistry))
   {
      fprintf( stderr, "Some NSNotificationCenter (%p) observers haven't unregistered yet!", self);
      [self dump];
   }
#endif

   // in "day to day" operations the queue contents are moved to another
   // queue, and we only destroy the old queue but not the contents
   // but here we kill all
   callbacks = sender_registry_callbacks;
   callbacks.valuecallback.release = (void (*)()) free_queue_and_contents;
   _mulle__map_done( (struct mulle__map *) &_senderRegistry, &callbacks, allocator);

   callbacks = name_registry_callbacks;
   callbacks.valuecallback.release = (void (*)()) free_queue_and_contents;
   _mulle__map_done( (struct mulle__map *) &_nameRegistry, &callbacks, allocator);

   callbacks = pair_registry_callbacks;
   callbacks.valuecallback.release = (void (*)()) free_queue_and_contents;
   _mulle__map_done( (struct mulle__map *) &_pairRegistry, &callbacks, allocator);

   // this one last
   callbacks = observer_registry_callbacks;
   callbacks.valuecallback.release = (void (*)()) free_queue_and_contents;
   _mulle__map_done( (struct mulle__map *) &_observerRegistry, &callbacks, allocator);

   mulle_thread_mutex_done( &_lock);

   [super dealloc];
}


#ifdef DEBUG
// for debugging only, its not locking
- (void) dump
{
   struct mulle_allocator    *allocator;
   char                      *s;

   allocator = MulleObjCInstanceGetAllocator( self);

   s = _mulle__map_describe( (struct mulle__map *) &_observerRegistry, &observer_registry_callbacks, allocator);
   if( s && *s)
      fprintf( stderr, "Observers: %s\n", s);
   mulle_allocator_free( allocator, s);

   s = _mulle__map_describe( (struct mulle__map *) &_pairRegistry, &pair_registry_callbacks, allocator);
   if( s && *s)
      fprintf( stderr, "Pairs: %s\n", s);
   mulle_allocator_free( allocator, s);

   s = _mulle__map_describe( (struct mulle__map *) &_nameRegistry, &name_registry_callbacks, allocator);
   if( s && *s)
      fprintf( stderr, "Names: %s\n", s);
   mulle_allocator_free( allocator, s);

   s = _mulle__map_describe( (struct mulle__map *) &_senderRegistry, &sender_registry_callbacks, allocator);
   if( s && *s)
      fprintf( stderr, "Senders: %s\n", s);
   mulle_allocator_free( allocator, s);
}
#endif


+ (instancetype) defaultCenter
{
   return( MulleObjCSingletonCreate( self));
}


#pragma mark - add and remove

/*
 * ADD
 */

static void  add_triplet_to_queue_for_key( struct mulle_map *table,
                                  void *key,
                                  observer_sel_imp_triplet *triplet)
{
   struct mulle__pointerqueue   *triplet_queue;
   struct mulle_allocator       *allocator;

   allocator     = mulle_map_get_allocator( table);
   triplet_queue = mulle_map_get( table, key);
   if( ! triplet_queue)
   {
      triplet_queue = mulle__pointerqueue_create( QUEUE_BUCKETSIZE, 0, allocator);  // spare allowance MUST be zero
      mulle_map_insert( table, key, triplet_queue);
   }
   _mulle__pointerqueue_push( triplet_queue, triplet, allocator);
}


- (void) addObserver:(id) observer
            selector:(SEL) sel
                name:(NSString *) name
              object:(id) sender
{
   name_sender_pair             *pair;
   name_sender_pair             key;
   observer_sel_imp_triplet     *triplet;
   observer_sel_imp_triplet     value;
   struct mulle__pointerqueue   *pair_queue;
   struct mulle_allocator       *allocator;

   // guess
   NSParameterAssert( observer);
   if( ! observer)
      return;

   if( Self._isFinalizing)
   {
      fprintf( stderr, "NSNotificationCenter ignored the add of an observer "
                       "during universe finalization\n");
      return;
   }

   allocator      = mulle_map_get_allocator( &self->_nameRegistry);

   value.observer = observer;
   value.sel      = sel;
   value.imp      = [observer methodForSelector:sel];
   triplet        = triplet_copy( &value, allocator);

   key.name       = name;
   key.sender     = sender;
   pair           = pair_copy( NULL, &key, allocator);

   /* these own the triplet */
   mulle_thread_mutex_lock( &_lock);
   {
      if( ! name)
      {
         if( ! sender)
            sender = (void *) &Self._OmniscientObserver;
         add_triplet_to_queue_for_key( &_senderRegistry, sender, triplet);
      }
      else
         if( ! sender)
            add_triplet_to_queue_for_key( &_nameRegistry, name, triplet);
         else
            add_triplet_to_queue_for_key( &_pairRegistry, pair, triplet);

      /* this owns the pair */
      pair_queue = mulle_map_get( &_observerRegistry, observer);
      if( ! pair_queue)
      {
         pair_queue = mulle__pointerqueue_create( QUEUE_BUCKETSIZE, 0, allocator);  // spare allowance MUST be zero
         mulle_map_insert( &_observerRegistry, observer, pair_queue);
      }
      _mulle__pointerqueue_push( pair_queue, pair, allocator);
      _mulle_atomic_pointer_increment( &_generationCount);
   }
   mulle_thread_mutex_unlock( &_lock);
}


/*
 * REMOVE
 */
static void    dequeueObserverForKey( struct mulle_map *table,
                                      void *key,
                                      void *observer,
                                      struct mulle_allocator *allocator)
{
   observer_sel_imp_triplet               *triplet;
   struct mulle__pointerqueue             *remaining;
   struct mulle__pointerqueue             *triplet_queue;
   struct mulle__pointerqueue             tmp;
   struct mulle__pointerqueueenumerator   rover;
   unsigned int                           bucketsize;

   triplet_queue = mulle_map_get( table, key);
   if( ! triplet_queue)
      return;

   remaining = NULL;
   while( triplet = _mulle__pointerqueue_pop( triplet_queue, allocator))
   {
      if( triplet->observer == observer)
      {
         mulle_allocator_free( allocator, triplet);
         continue;
      }

      // push non-matching observers on a clean temporary queue
      if( ! remaining)
      {
         remaining  = &tmp;
         bucketsize = _mulle__pointerqueue_get_bucketsize( triplet_queue);
         _mulle__pointerqueue_init( remaining, bucketsize, 0);
      }
      _mulle__pointerqueue_push( remaining, triplet, allocator);
   }
   mulle__pointerqueueenumerator_done( &rover);

   //
   //
   // the original triplet_queue should be empty now in any case
   // if no remaining left, we can drop the entry
   //
   if( ! remaining)  // 1 and 2
   {
      mulle_map_remove( table, key);
      return;
   }

   assert( _mulle__pointerqueue_get_count( triplet_queue) == 0);

   // make remaining triplets the contents of the queue
   _mulle__pointerqueue_done( triplet_queue, allocator);
   *triplet_queue = *remaining;
}


static void   removePairFromQueues( NSNotificationCenter *self,
                                    name_sender_pair *pair,
                                    id observer,
                                    struct mulle_allocator *allocator)
{
   if( ! pair->name)
   {
      dequeueObserverForKey( &self->_senderRegistry,
                             pair->sender ? pair->sender : (void *) &Self._OmniscientObserver,
                             observer,
                             allocator);
   }
   else
      if( ! pair->sender)
         dequeueObserverForKey( &self->_nameRegistry, pair->name, observer, allocator);
      else
         dequeueObserverForKey( &self->_pairRegistry, pair, observer, allocator);
}


- (void) removeObserver:(id) observer
{
   struct mulle__pointerqueue   *pair_queue;
   struct mulle_allocator       *allocator;
   name_sender_pair             *pair;

   mulle_thread_mutex_lock( &_lock);
   {
      pair_queue = mulle_map_get( &_observerRegistry, observer);
      if( pair_queue)
      {

         allocator = mulle_map_get_allocator( &_observerRegistry);

         _mulle__map_remove( (struct mulle__map *) &_observerRegistry,
                            observer,
                            &observer_no_free_registry_callbacks,
                            allocator);

         while( pair = _mulle__pointerqueue_pop( pair_queue, allocator))
         {
            removePairFromQueues( self, pair, observer, allocator);
            pair_destroy( NULL, pair, allocator);
         }

         _mulle__pointerqueue_destroy( pair_queue, allocator);
         _mulle_atomic_pointer_increment( &_generationCount);
      }
   }
   mulle_thread_mutex_unlock( &_lock);
}


- (void) removeObserver:(id) observer
                   name:(NSString *) name
                 object:(id) sender
{
   struct mulle__pointerqueueenumerator   rover;
   struct mulle__pointerqueue             *pair_queue;
   struct mulle__pointerqueue             *new_queue;
   struct mulle_allocator                 *allocator;
   name_sender_pair                       *pair;
   unsigned int                           bucketsize;

   mulle_thread_mutex_lock( &_lock);
   {
      pair_queue = mulle_map_get( &_observerRegistry, observer);
      if( pair_queue)
      {
         allocator  = mulle_map_get_allocator( &self->_observerRegistry);
         bucketsize = _mulle__pointerqueue_get_bucketsize( pair_queue);
         new_queue  = mulle__pointerqueue_create( bucketsize, 0, allocator);

         rover = mulle__pointerqueue_enumerate( pair_queue);
         while( _mulle__pointerqueueenumerator_next( &rover, (void **) &pair))
         {
            if( (sender && sender != pair->sender) ||
                (name && ! (name == pair->name || [name isEqualToString:pair->name])))
            {
               _mulle__pointerqueue_push( new_queue, pair, allocator);
               continue;
            }

            removePairFromQueues( self, pair, observer, allocator);
            pair_destroy( NULL, pair, allocator);
         }
         mulle__pointerqueueenumerator_done( &rover);

         // reap old one, don't insert new one if empty
         mulle_map_remove( &_observerRegistry, observer);
         if( _mulle__pointerqueue_get_count( new_queue))
            mulle_map_insert( &_observerRegistry, observer, new_queue);
         else
            _mulle__pointerqueue_destroy( new_queue, allocator);

         _mulle_atomic_pointer_increment( &_generationCount);
      }
   }
   mulle_thread_mutex_unlock( &_lock);
}


#pragma mark - send notifications
//
// It is important for MulleEOF that if observers a,b,c are registering in the
// order a,b,c that they are then messaged in reverse order c,b,a.
// That way a later observer can override a previous observer and we don't
// necessarily need to execute both code.
//
BOOL   MulleObjCNotificationCenterObserverStillPresentInQueue( NSNotificationCenter *self,
                                                               struct mulle_map *map,
                                                               void *key,
                                                               id observer)
{
   struct mulle__pointerqueueenumerator   rover;
   struct mulle__pointerqueue             *queue;
   observer_sel_imp_triplet               *p;
   BOOL                                   isPresent;

   isPresent = NO;
   mulle_thread_mutex_lock( &self->_lock);
   {
      queue = mulle_map_get( map, key);
      if( queue)
      {
         //
         // need to copy, to allow modifications
         //
         rover = mulle__pointerqueue_enumerate( queue);
         while( _mulle__pointerqueueenumerator_next( &rover, (void **) &p))
         {
            if( p->observer == observer)
            {
               isPresent = YES;
               break;
            }
         }
         mulle__pointerqueueenumerator_done( &rover);
      }
   }
   mulle_thread_mutex_unlock( &self->_lock);
   return( isPresent);
}


static void
  NSNotificationCenterNotifyReceiversOfQueue( NSNotificationCenter *self,
                                              struct mulle_map *map,
                                              void *key,
                                              NSNotification *notification)
{
   observer_sel_imp_triplet     *p;
   observer_sel_imp_triplet     *sentinel;
   struct mulle__pointerqueue   *queue;
   NSUInteger                   i, n;
   intptr_t                     generationCount;

   mulle_alloca_do( buf, observer_sel_imp_triplet, 32)
   {
      mulle_thread_mutex_do( self->_lock)
      {
         generationCount = (intptr_t) _mulle_atomic_pointer_read( &self->_generationCount);

         n     = 0;
         queue = mulle_map_get( map, key);
         if( queue)
         {
            //
            // need to copy, to allow modifications
            //
            n = _mulle__pointerqueue_get_count( queue);
            mulle_alloca_do_realloc( buf, n);

            i = 0;
            mulle__pointerqueue_for( queue, p)
            {
               buf[ i] = *p;
               [[buf[ i].observer retain] autorelease];  // observer pointer remains stable
               ++i;
            }

            assert( i = n);
         }
      }

      //
      // Call in reverse order for MulleEOF and other overriding benefit
      //
      sentinel = buf;         // if n is 0 , buf can be garbage
      p        = &buf[ n];
      while( p > sentinel)
      {
         --p;
         if( generationCount == (intptr_t) _mulle_atomic_pointer_read( &self->_generationCount) ||
             MulleObjCNotificationCenterObserverStillPresentInQueue( self, map, key, p->observer))
            (*p->imp)( p->observer, p->sel, notification);
      }
   }
}


static void   post_pair( NSNotificationCenter *self,
                         name_sender_pair *pair,
                         NSNotification *notification)
{
   NSNotificationCenterNotifyReceiversOfQueue( self, &self->_pairRegistry, pair, notification);
}


static void   post_name( NSNotificationCenter *self,
                         NSString *name,
                         NSNotification *notification)
{
   NSNotificationCenterNotifyReceiversOfQueue( self, &self->_nameRegistry, name, notification);
}


static void   post_sender( NSNotificationCenter *self,
                           id sender,
                           NSNotification *notification)
{
   NSNotificationCenterNotifyReceiversOfQueue( self, &self->_senderRegistry, sender, notification);
}



static void   NSNotificationCenterPostNotification( NSNotificationCenter  *self,
                                                    NSNotification *notification)
{
   name_sender_pair   pair;

   if( Self._isFinalizing)
   {
      fprintf( stderr, "NSNotificationCenter ignored the posting of a notification "
                       "during universe finalization\n");
      return;
   }

   pair.name   = [notification name];
   pair.sender = [notification object];

   //
   // TODO: figure out, if this order is somehow important somewhere
   //       is it useful to notify omniscients first or last ?
   //
   _mulle_atomic_pointer_increment( &self->_isNotifying);

   if( pair.sender)
   {
      post_pair( self, &pair, notification);
      post_sender( self, pair.sender, notification);
   }

   post_name( self, pair.name, notification);
   post_sender( self, (void *) &Self._OmniscientObserver, notification);

   _mulle_atomic_pointer_decrement( &self->_isNotifying);
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

@end

