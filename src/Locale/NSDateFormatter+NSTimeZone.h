//
//  NSDateFormatter+NSTimeZone.h
//  MulleObjCFoundation
//
//  Created by Nat! on 05.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"


@class NSTimeZone;


@interface NSDateFormatter (NSTimeZone)

- (NSTimeZone *) timeZone;
- (void) setTimeZone:(NSTimeZone *) locale;

@end
