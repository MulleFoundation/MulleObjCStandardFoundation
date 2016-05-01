//
//  MulleObjCContainerCallback.h
//  MulleObjCFoundation
//
//  Created by Nat! on 16.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

// in principle you can include this in C, but why ?

#ifndef MulleObjCContainerCallback_h__
#define MulleObjCContainerCallback_h__

#include <MulleObjC/ns_objc.h>
#include <mulle_container/mulle_container.h>

//
// these are "const" to make them reside possibly in
// writeprotected storage, which can be convenient for
// catching accidental writes into them
//
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueRetainCallback;
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueRetainCallback;
// NSDictionary usually uses this
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueCopyCallback;
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueCopyCallback;

// i was too lazy to multiply it out, do it if needed
extern const struct mulle_container_keycallback      _MulleObjCContainerObjectKeyAssignCallback;
extern const struct mulle_container_valuecallback    _MulleObjCContainerObjectValueAssignCallback;


extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyRetainCallback;
// NSSet usually uses this
extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyCopyCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueRetainCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueCopyCallback;


#define NSObjectMapKeyCallBacks                *MulleObjCContainerObjectKeyRetainCallback
#define NSObjectMapValueCallBacks              *MulleObjCContainerObjectValueRetainCallback
#define NSNonRetainedObjectMapKeyCallBacks     _MulleObjCContainerObjectKeyAssignCallback
#define NSNonRetainedObjectMapValueCallBacks   _MulleObjCContainerObjectValueAssignCallback


extern struct mulle_container_keycallback     NSIntMapKeyCallBacks;
extern struct mulle_container_keycallback     NSIntegerMapKeyCallBacks;
extern struct mulle_container_valuecallback   NSIntMapValueCallBacks;
extern struct mulle_container_valuecallback   NSIntegerMapValueCallBacks;
extern struct mulle_container_keycallback     NSNonOwnedPointerMapKeyCallBacks;
extern struct mulle_container_keycallback     NSOwnedPointerMapKeyCallBacks;
extern struct mulle_container_valuecallback   NSNonOwnedPointerMapValueCallBacks;
extern struct mulle_container_valuecallback   NSOwnedPointerMapValueCallBacks;


#endif
