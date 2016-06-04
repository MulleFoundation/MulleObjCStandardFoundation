/*
 *  MulleFoundation - the mulle-objc class library
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



@implementation NSObject( _NSNull)

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


- (id) initWithCoder:(NSCoder *) coder
{
   return( [self init]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
}


+ (NSNull *) null
{
   return( MulleObjCSingletonCreate( self));
}


- (id) copy
{
   return( self);
}


- (NSComparisonResult) compare:(id) other
{
   if( other == self)
      return( NSOrderedSame);
   if( ! other)
      return( NSOrderedSame);
   return( NSOrderedAscending);
}

@end
