//
//  NSObject+String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 22.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationBase.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation NSObject (String)

+ (NSString *) description
{
   return( NSStringFromClass( self));
}


- (NSString *) description
{
   return( [NSString stringWithFormat:@"<%@ %p>", [self class], self]);
}

@end
