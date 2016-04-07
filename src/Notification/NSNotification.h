/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNotification.h is a part of MulleFoundation
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


@class NSString;
@class NSDictionary;


@interface NSNotification : NSObject

@property(copy)   NSString      *name;
@property(retain) id            object;
@property(retain) NSDictionary  *userInfo;

+ (id) notificationWithName:(NSString *) aName 
                     object:(id) anObject;
                     
+ (id) notificationWithName:(NSString *) aName 
                     object:(id) anObject 
                   userInfo:(NSDictionary *) userInfo;

@end

