//
//  NSException+String.m
//  MulleObjCFoundation
//
//  Created by Nat! on 22.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSException.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

@implementation NSException (String)

- (NSString *) description
{
   return( [NSString stringWithFormat:@"%@ %@ { %@ }",
               [self name],
               [self reason],
               [self userInfo]]);;
}
            
@end
