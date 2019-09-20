//
//  NSNotificationCenter.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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

#import "MulleObjCFoundationBase.h"

#import <mulle-container/mulle-container.h>


@class NSDictionary;
@class NSNotification;
@class NSString;


@interface NSNotificationCenter : NSObject < MulleObjCSingleton>
{
   mulle_thread_mutex_t     _lock;
   struct mulle_map         _pairRegistry;
   struct mulle_map         _nameRegistry;
   struct mulle_map         _senderRegistry;

   struct mulle_map         _observerRegistry;
   mulle_atomic_pointer_t   _isNotifying;    // for debugging
   mulle_atomic_pointer_t   _generationCount;
}


//
// currently, this is "app-wide" but shouldn't this be thread local ?
// It would a) reduce complexity b) reduce surprise by being called from
// a different thread.
// Possible fix: tie observer to thread, and raise on mismatch ?
//
+ (instancetype) defaultCenter;

- (void) addObserver:(id) observer
            selector:(SEL) sel
                name:(NSString *) name
              object:(id) sender;

- (void) postNotification:(NSNotification *) notification;
- (void) postNotificationName:(NSString *) name
                       object:(id) sender;
- (void) postNotificationName:(NSString *) name
                       object:(id) sender
                     userInfo:(NSDictionary *) userInfo;

- (void) removeObserver:(id) observer;

- (void) removeObserver:(id) observer
                   name:(NSString *) name
                 object:(id) sender;
@end


extern NSString   *MulleObjCUniverseWillFinalizeNotification; // @"MulleObjCUniverseWillFinalizeNotification";
