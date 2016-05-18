//
//  NSNumber+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 14.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber+NSString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies


@implementation NSNumber (NSString)

- (id) description
{
   return( [NSString stringWithFormat:@"%lld", [self longLongValue]]);
}


- (NSString *) _debugContentsDescription
{
   return( [self description]);
}

@end
