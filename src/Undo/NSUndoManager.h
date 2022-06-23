//
//  NSUndoManager.h
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 13.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
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
@interface NSUndoManager : NSObject
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

