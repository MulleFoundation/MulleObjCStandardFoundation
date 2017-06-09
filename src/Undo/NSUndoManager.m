//
//  NSUndoManager.m
//  MulleObjCFoundation
//
//  Created by Nat! on 13.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSUndoManager.h"

#import "MulleObjCFoundationContainer.h"

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
   NSMutableDictionary  *marker;

   ++_groupingLevel;
   marker = [NSMutableDictionary dictionary];
   [marker setObject:@"begin"
              forKey:@"type"];
   [_undoStack addObject:marker];
}

- (void) endUndoGrouping;
{
   NSMutableDictionary  *marker;

   if( ! _groupingLevel)
      MulleObjCThrowInternalInconsistencyException( @"%s called too often", __PRETTY_FUNCTION__);
   --_groupingLevel;

   marker = [NSMutableDictionary dictionary];
   [marker setObject:@"end"
              forKey:@"type"];
   [_undoStack addObject:marker];
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
                       selector:(SEL) selector
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


- (id) prepareWithInvocationTarget:(id) target
{
}

@end
