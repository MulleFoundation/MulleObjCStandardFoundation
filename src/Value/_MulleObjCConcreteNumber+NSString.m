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



@implementation _MulleObjCUInt32Number (NSString)

- (id) description
{
   return( [NSString stringWithFormat:@"%lu", [self unsignedLongValue]]);
}

@end


@implementation _MulleObjCUInt64Number (NSString)

- (id) description
{
   return( [NSString stringWithFormat:@"%llu", [self unsignedLongLongValue]]);
}

@end


@implementation _MulleObjCDoubleNumber (NSString)

- (id) description
{
   return( [NSString stringWithFormat:@"%f", [self doubleValue]]);
}

@end


@implementation _MulleObjCLongDoubleNumber (NSString)

- (id) description
{
   return( [NSString stringWithFormat:@"%Lf", [self longDoubleValue]]);
}

@end
