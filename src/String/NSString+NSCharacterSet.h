//
//  NSString+NSCharacterSet.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


@class NSCharacterSet;


@interface NSString (NSCharacterSet)

- (NSString *) stringByTrimmingCharactersInSet:(NSCharacterSet *) set;

@end
