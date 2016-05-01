//
//  NSDate+NSLocale.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationValue.h"


@class NSLocale;


@interface NSDate (NSLocale)

- (NSString *) descriptionWithLocale:(NSLocale *) locale;

@end
