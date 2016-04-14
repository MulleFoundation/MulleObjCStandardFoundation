//
//  _MulleObjCConcreteNumber+NSString.m
//  MulleObjCFoundation
//
//  Created by Nat! on 14.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "_MulleObjCConcreteNumber.h"


// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c dependencies


@implementation _MulleObjCDoubleNumber (NSString)

- (NSString *) description
{
   return( [NSString stringWithFormat:@"%f", [self doubleValue]]);
}

@end
