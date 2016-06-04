/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSNotification.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNotification.h"


@implementation NSNotification

static void   init( NSNotification *self,
                    NSString *name,
                    id obj,
                    NSDictionary *userInfo)
{
   self->_name     = [name copy];
   self->_object   = [obj retain];
   self->_userInfo = [userInfo retain];
}


+ (id) notificationWithName:(NSString *) name 
                     object:(id) obj;
{
   NSNotification   *notification;
   
   if( ! name)
      MulleObjCThrowInvalidArgumentException( @"name is nil");

   notification = [NSAllocateObject( self, 0, NULL) autorelease];
   init( notification, name, obj, NULL);
   return( notification);
}                     


+ (id) notificationWithName:(NSString *) name 
                     object:(id) obj 
                   userInfo:(NSDictionary *) userInfo
{
   NSNotification   *notification;
   
   if( ! name)
      MulleObjCThrowInvalidArgumentException( @"name is nil");

   notification = [NSAllocateObject( self, 0, NULL) autorelease];
   init( notification, name, obj, userInfo);
   
   return( notification);
}

@end

