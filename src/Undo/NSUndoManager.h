//
//  NSUndoManager.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2017 Nat! - Mulle kybernetiK.
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
#import "import.h"


@class NSArray;
@class NSString;
@class NSMutableArray;


enum
{
   NSUndoCloseGroupingRunLoopOrdering  = 350000
};


//
// NSUndoManager is per thread object, tied to a future
// NSRunLoop, so there is no atomicity or locking here
//
enum _NSUndoManagerState
{
   _NSUndoManagerIsUndoing = 1,
   _NSUndoManagerIsRedoing = 2
};

// INCOMPLETE!!
@interface NSUndoManager : NSObject <MulleObjCThreadUnsafe>
{
   NSMutableArray             *_undoStack;
   NSMutableArray             *_redoStack;
   id                         _target;
   NSUInteger                 _disabledCount;
   NSUInteger                 _groupingLevel;
   enum _NSUndoManagerState   _state;
}

@property( assign) BOOL         groupsByEvent;
@property( assign) NSUInteger   levelsOfUndo;
@property( copy)   NSArray      *runLoopModes;

- (NSInteger) groupingLevel;

- (void) beginUndoGrouping;
- (void) endUndoGrouping;

- (void) disableUndoRegistration;
- (void) enableUndoRegistration;
- (BOOL) isUndoRegistrationEnabled;

- (void) undo;
- (void) redo;
- (void) undoNestedGroup;

- (BOOL) canUndo;
- (BOOL) canRedo;

- (BOOL) isUndoing;
- (BOOL) isRedoing;

- (void) removeAllActions;
- (void) removeAllActionsWithTarget:(id) target;
- (void) registerUndoWithTarget:(id) target
                       selector:(SEL) selector
                       object:(id) anObject;
- (id) prepareWithInvocationTarget:(id) target;


@end

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerCheckpointNotification;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerDidCloseUndoGroupNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerDidOpenUndoGroupNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerWillCloseUndoGroupNotification;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerDidRedoChangeNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerWillRedoChangeNotification;

MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerDidUndoChangeNotification;
MULLE_OBJC_STANDARD_FOUNDATION_GLOBAL NSString   *NSUndoManagerWillUndoChangeNotification;

