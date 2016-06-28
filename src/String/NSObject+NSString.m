//
//  NSObject+String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 22.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjC/MulleObjC.h>

// other files in this library
#import "NSString.h"
#import "NSString+Sprintf.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"

// std-c and dependencies


@implementation NSObject (NSString)

+ (id) description
{
   return( NSStringFromClass( self));
}


- (NSString *) _debugContentsDescription
{
   return( nil);
}


- (NSString *) debugDescription
{
   NSString     *contents;
   NSUInteger   length;
   
   contents = [self _debugContentsDescription];
   length   = [contents length];
   if( ! length)
      return( [NSString stringWithFormat:@"<%@ %p>", [self class], self]);
   
   if( length >= 8192)
      return( [NSString stringWithFormat:@"<%@ %p %.8192@...", [self class], self, contents]);
   
   return( [NSString stringWithFormat:@"<%@ %p %@>", [self class], self, contents]);
}

@end
