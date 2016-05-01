//
//  NSDictionary+NSLocale.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationContainer.h"

@class NSLocale;


@interface NSDictionary (NSLocale)

- (NSString *) descriptionWithLocale:(id) locale
                              indent:(NSUInteger) level;
- (NSString *) descriptionWithLocale:(NSLocale *) locale;

@end
