//
//  NSMethodSignature+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 16.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import <MulleObjC/MulleObjC.h>

// other files in this library
#import "NSString+Sprintf.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSMethodSignature (NSString)

- (NSString *) _debugContentsDescription
{
   return( [NSString stringWithFormat:@"\"%s\"", _types]);
}

@end
