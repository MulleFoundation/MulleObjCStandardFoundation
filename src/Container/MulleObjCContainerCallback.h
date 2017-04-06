//
//  MulleObjCContainerCallback.h
//  MulleObjCFoundation
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
extern struct mulle_container_valuecallback   NSIntMapValueCallBacks;
extern struct mulle_container_keycallback     NSIntegerMapKeyCallBacks;
extern struct mulle_container_valuecallback   NSIntegerMapValueCallBacks;
extern struct mulle_container_keycallback     NSNonOwnedPointerMapKeyCallBacks;
extern struct mulle_container_valuecallback   NSNonOwnedPointerMapValueCallBacks;
extern struct mulle_container_keycallback     NSOwnedPointerMapKeyCallBacks;
extern struct mulle_container_valuecallback   NSOwnedPointerMapValueCallBacks;



//extern NSHashTableCallBacks   MulleObjCNonRetainedObjectHashCallBacks;
//extern NSHashTableCallBacks   MulleObjCObjectHashCallBacks;
//extern NSHashTableCallBacks   MulleObjCOwnedObjectIdentityHashCallBacks;


#endif
