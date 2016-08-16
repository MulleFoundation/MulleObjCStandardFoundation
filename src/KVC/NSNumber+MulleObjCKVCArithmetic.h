//
//  NSNumber+MulleObjCKVCArithmetic.h
//  MulleObjCFoundation
//
//  Created by Nat! on 17.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"

//
// some small routines used for arithmetic in collection operators
// in general though, arithmetic on NSNumber is a bad idea
//
@interface NSNumber (MulleObjCKVCArithmetic)

- (NSNumber *) _add:(NSNumber *) other;
- (NSNumber *) _divideByInteger:(NSUInteger) divisor;

@end
