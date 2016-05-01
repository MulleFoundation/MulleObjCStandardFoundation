//
//  MulleContainerCallback.m
//  MulleObjCFoundation
//
//  Created by Nat! on 16.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjC/MulleObjC.h>



// other files in this library
#import "MulleObjCContainerCallback.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies



#pragma mark -
#pragma mark Int

static void   *mulle_container_callback_int_describe( struct mulle_container_valuecallback  *callback, void *p, struct mulle_allocator *allocator)
{
   return( [NSString stringWithFormat:@"%d", (int) (uintptr_t) p]);
}


static void   *mulle_container_callback_intptr_describe( struct mulle_container_valuecallback  *callback, void *p, struct mulle_allocator *allocator)
{
   return( [NSString stringWithFormat:@"%lld", (long long) (uintptr_t) p]);
}


struct mulle_container_keycallback      NSIntMapKeyCallBacks =
{
   (void *) mulle_hash_pointer,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_int_describe,
   mulle_container_not_an_int_key,
   NULL
};

struct mulle_container_keycallback      NSIntegerMapKeyCallBacks =
{
   (void *) mulle_hash_pointer,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_intptr_describe,
   mulle_container_not_an_intptr_key,
   NULL
};


struct mulle_container_valuecallback    NSIntMapValueCallBacks =
{
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_int_describe,
   NULL
};



struct mulle_container_valuecallback    NSIntegerMapValueCallBacks =
{
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_intptr_describe,
   NULL
};


#pragma mark -
#pragma mark Pointer

static void   *mulle_container_callback_pointer_describe( struct mulle_container_valuecallback  *callback, void *p, struct mulle_allocator *allocator)
{
   return( [NSString stringWithFormat:@"%p", p]);
}



struct mulle_container_keycallback   NSNonOwnedPointerMapKeyCallBacks =
{
   (void *) mulle_hash_pointer,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_pointer_describe,
   NULL,
   NULL
};



struct mulle_container_keycallback   NSOwnedPointerMapKeyCallBacks =
{
   (void *) mulle_hash_pointer,
   (void *) mulle_container_callback_pointer_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_keycallback_pointer_free,
   (void *) mulle_container_callback_pointer_describe,
   NULL,
   NULL
};


struct mulle_container_valuecallback   NSNonOwnedPointerMapValueCallBacks =
{
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_callback_pointer_describe,
   NULL
};



struct mulle_container_valuecallback   NSOwnedPointerMapValueCallBacks =
{
   (void *) mulle_container_callback_self,
   (void *) mulle_container_valuecallback_pointer_free,
   (void *) mulle_container_callback_pointer_describe,
   NULL
};


#pragma mark -
#pragma mark Object


static uintptr_t  mulle_container_keycallback_object_hash( struct mulle_container_keycallback *callback, id obj)
{
   return( (uintptr_t) [obj hash]);
}


static int   mulle_container_keycallback_object_is_equal( struct mulle_container_keycallback *callback, id obj, id other)
{
   return( [obj isEqual:other]);
}


static void   *mulle_container_keycallback_object_retain( struct mulle_container_keycallback *callback, id obj)
{
   return( [obj retain]);
}


static void   *mulle_container_keycallback_object_copy( struct mulle_container_keycallback *callback, id obj)
{
   return( [obj copy]);
}


static void   mulle_container_keycallback_object_autorelease( struct mulle_container_keycallback *callback, id obj)
{
   [obj autorelease];
}


static void   *mulle_container_keycallback_object_describe( struct mulle_container_keycallback *callback, id obj)
{
   return( [obj description]);
}


const struct mulle_container_keycallback   _MulleObjCContainerObjectKeyAssignCallback =
{
   (void *) mulle_container_keycallback_object_hash,
   (void *) mulle_container_keycallback_object_is_equal,
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_keycallback_object_describe,
   
   nil,
   NULL
};


const struct mulle_container_valuecallback   _MulleObjCContainerObjectValueAssignCallback =
{
   (void *) mulle_container_callback_self,
   (void *) mulle_container_callback_nop,
   (void *) mulle_container_keycallback_object_describe,
   NULL
};


const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueRetainCallback =
{
   {
      (void *) mulle_container_keycallback_object_hash,
      (void *) mulle_container_keycallback_object_is_equal,
      (void *) mulle_container_keycallback_object_retain,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      
      nil,
      NULL
   },
   {
      (void *) mulle_container_keycallback_object_retain,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      NULL
   }
};


const  struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueRetainCallback =
{
   {
      (void *) mulle_container_keycallback_object_hash,
      (void *) mulle_container_keycallback_object_is_equal,
      (void *) mulle_container_keycallback_object_copy,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      
      nil,
      NULL
   },
   {
      (void *) mulle_container_keycallback_object_retain,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueCopyCallback =
{
   {
      (void *) mulle_container_keycallback_object_hash,
      (void *) mulle_container_keycallback_object_is_equal,
      (void *) mulle_container_keycallback_object_retain,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      
      nil,
      NULL
   },
   {
      (void *) mulle_container_keycallback_object_copy,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      NULL
   }
};

const  struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueCopyCallback =
{
   {
      (void *) mulle_container_keycallback_object_hash,
      (void *) mulle_container_keycallback_object_is_equal,
      (void *) mulle_container_keycallback_object_copy,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      
      nil,
      NULL
   },
   {
      (void *) mulle_container_keycallback_object_copy,
      (void *) mulle_container_keycallback_object_autorelease,
      (void *) mulle_container_keycallback_object_describe,
      NULL
   }
};


extern struct mulle_container_keyvaluecallback   MulleObjCContainerObjectKeyRetainValueCopyCallback;
extern struct mulle_container_keyvaluecallback   MulleObjCContainerObjectKeyCopyValueRetainCallback;
extern struct mulle_container_keyvaluecallback   MulleObjCContainerObjectKeyCopyValueCopyCallback;

extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyRetainCallback;
extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyCopyCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueRetainCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueCopyCallback;

struct mulle_container_keycallback     *MulleObjCContainerObjectKeyRetainCallback    = (void *) &_MulleObjCContainerObjectKeyRetainValueRetainCallback.keycallback;
struct mulle_container_valuecallback   *MulleObjCContainerObjectValueRetainCallback  = (void *) &_MulleObjCContainerObjectKeyRetainValueRetainCallback.valuecallback;
;

struct mulle_container_keycallback     *MulleObjCContainerObjectKeyCopyCallback    = (void *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback.keycallback;
struct mulle_container_valuecallback   *MulleObjCContainerObjectValueCopyCallback  = (void *) &_MulleObjCContainerObjectKeyCopyValueCopyCallback.valuecallback;

