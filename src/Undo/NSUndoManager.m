//
//  NSUndoManager.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 13.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSUndoManager.h"

#import "MulleObjCStandardFoundationContainer.h"
#import "MulleObjCStandardFoundationException.h"
#import "MulleObjCStandardFoundationNotification.h"
#import "MulleObjCStandardFoundationString.h"


@implementation NSUndoManager

- (instancetype) init
{
   _undoStack = [NSMutableArray new];
   _redoStack = [NSMutableArray new];

   return( self);
}


- (void) dealloc
{
   [_redoStack release];
   [_undoStack release];

   [super dealloc];
}


- (void) beginUndoGrouping
{
   NSDictionary  *marker;

   marker = [NSDictionary dictionaryWithObjectsAndKeys:@"begin", @"type", @(_groupingLevel), @"level", nil];
   ++_groupingLevel;
   [_undoStack addObject:marker];
}


- (void) endUndoGrouping;
{
   NSDictionary  *marker;

   if( ! _groupingLevel)
      MulleObjCThrowInternalInconsistencyException( @"%s called too often", __PRETTY_FUNCTION__);
   --_groupingLevel;

   marker = [NSDictionary dictionaryWithObjectsAndKeys:@"end", @"type", @(_groupingLevel), @"level", nil];

   marker = [NSDictionary dictionaryWithObject:@"end"
                                        forKey:@"type"];
   [_undoStack addObject:marker];
}


- (NSInteger) groupingLevel
{
   return( _groupingLevel);
}


- (void) disableUndoRegistration
{
   _disabledCount++;
}

- (void) enableUndoRegistration
{
   if( ! _disabledCount)
      MulleObjCThrowInternalInconsistencyException( @"%s called too often", __PRETTY_FUNCTION__);
   --_disabledCount;
}


- (BOOL) isUndoRegistrationEnabled
{
   return( ! _disabledCount);
}


- (BOOL) canUndo
{
   return( [_undoStack count] != 0);
}


- (BOOL) canRedo
{
   return( [_redoStack count] != 0);
}


- (BOOL) isUndoing
{
   return( _state == _NSUndoManagerIsUndoing);
}


- (BOOL) isRedoing
{
   return( _state == _NSUndoManagerIsRedoing);
}


- (void) registerUndoWithTarget:(id) target
                       selector:(SEL) sel
                       object:(id) anObject
{
   NSMethodSignature     *signature;
   NSInvocation          *invocation;
   NSMutableDictionary   *info;

   signature  = [target methodSignatureForSelector:sel];
   invocation = [NSInvocation invocationWithMethodSignature:signature];
   [invocation setTarget:target];
   [invocation setArgument:anObject
                   atIndex:2];
   [invocation retainArguments];

   info = [NSMutableDictionary dictionary];
   [info setObject:@"invocation"
              forKey:@"type"];
   [info setObject:invocation
            forKey:@"invocation"];
   [_undoStack addObject:info];
}

- (void) removeAllActions
{
   [_undoStack removeAllObjects];
   [_redoStack removeAllObjects];
   _disabledCount = 0;
}


static void   removeDictionariesMatchingTargetFromStack( NSMutableArray *stack,
                                                         id target)
{
   NSMutableArray  *candidates;
   NSDictionary    *info;

   for( info in stack)
      if( [[info objectForKey:@"invocation"] target] == target)
      {
         if( ! candidates)
            candidates = [NSMutableArray array];
         [candidates addObject:info];
      }

   [stack removeObjectsInArray:candidates];
}


- (void) removeAllActionsWithTarget:(id) target
{
   removeDictionariesMatchingTargetFromStack( _undoStack, target);
   removeDictionariesMatchingTargetFromStack( _redoStack, target);
}


- (id) prepareWithInvocationTarget:(id) target
{
   _target = target;
   return( self);  // should return a proxy object here, but I don't know what
}


static void   performLastStackInvocation( NSMutableArray *stack, id target)
{
   NSDictionary   *info;
   NSInvocation   *invocation;

   info = [stack lastObject];
   if( ! info)
      return;

   invocation = [info objectForKey:@"invocation"];
   if( target)
      [invocation setTarget:target];
   [invocation invoke];

   [stack removeLastObject];
}


- (void) undo
{
   NSNotificationCenter   *center;

   center = [NSNotificationCenter defaultCenter];
   [center postNotificationName:NSUndoManagerWillUndoChangeNotification
                         object:self];
   performLastStackInvocation( _undoStack, _target);
   [center postNotificationName:NSUndoManagerDidUndoChangeNotification
                         object:self];
}


- (void) redo
{
   NSNotificationCenter   *center;

   center = [NSNotificationCenter defaultCenter];
   [center postNotificationName:NSUndoManagerWillRedoChangeNotification
                         object:self];
   performLastStackInvocation( _redoStack, _target);
   [center postNotificationName:NSUndoManagerDidRedoChangeNotification
                         object:self];
}


- (void) undoNestedGroup
{
   NSNotificationCenter   *center;

   center = [NSNotificationCenter defaultCenter];
   [center postNotificationName:NSUndoManagerCheckpointNotification
                         object:self];
   /* TODO: checkpoint something here */
   [self undo];
}

@end
