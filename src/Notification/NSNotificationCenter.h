/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNotificationCenter.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */

#import <MulleObjC/MulleObjC.h>

#import <mulle_container/mulle_container.h>


@class NSDictionary;
@class NSNotification;
@class NSString;


@interface NSNotificationCenter : NSObject
{
   struct mulle_map   _pairRegistry;
   struct mulle_map   _nameRegistry;
   struct mulle_map   _senderRegistry;

   struct mulle_map   _observerRegistry;
}


+ (id) defaultCenter;

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

@end

