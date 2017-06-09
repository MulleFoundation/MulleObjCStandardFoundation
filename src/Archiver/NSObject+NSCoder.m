//
//  NSObject+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 21.04.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSObject+NSCoder.h"


@implementation NSObject (NSCoder)

- (Class) classForCoder
{
   return( [self class]);
}

@end
