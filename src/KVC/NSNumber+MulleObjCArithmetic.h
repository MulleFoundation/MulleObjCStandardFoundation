//
//  NSNumber+MulleObjCArithmetic.h
//  MulleObjCFoundation
//
//  Created by Nat! on 17.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"

//
// some small routines used for arithmetic in collection operators
// in general though, aritmetic on NSNumber is a bad idea
//
@interface NSNumber (MulleObjCArithmetic)

- (NSNumber *) _add:(NSNumber *) other;
- (NSNumber *) _divideByInteger:(NSUInteger) divisor;

@end
