/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSNull.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSNull.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
// std-c and dependencies



@implementation NSObject( NSNull)

- (BOOL) __isNSNull
{
   return( NO);
}

@end


@implementation NSNull

- (BOOL) __isNSNull
{
   return( YES);
}


+ (NSNull *) null
{
   return( MulleObjCSingletonCreate( self));
}


- (id) copy
{
   return( self);
}

@end
