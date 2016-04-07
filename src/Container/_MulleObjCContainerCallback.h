//
//  MulleObjCContainerCallback.h
//  MulleObjCFoundation
//
//  Created by Nat! on 16.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

// in principle you can include this in C, but why ?

#ifndef MulleObjCContainerObjectKeyValueCallback_h__
#define MulleObjCContainerObjectKeyValueCallback_h__

#include <MulleObjC/ns_objc.h>
#include <mulle_container/mulle_container.h>

// these are "const" to make them reside possibly in
// writeprotected storage, which can be convenient for
// catching accidental writes into them
//
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueRetainCallback;
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueRetainCallback;
// NSDictionary usually uses this
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyRetainValueCopyCallback;
extern const struct mulle_container_keyvaluecallback   _MulleObjCContainerObjectKeyCopyValueCopyCallback;

extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyRetainCallback;
// NSSet usually uses this
extern struct mulle_container_keycallback     *MulleObjCContainerObjectKeyCopyCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueRetainCallback;
extern struct mulle_container_valuecallback   *MulleObjCContainerObjectValueCopyCallback;

#endif
