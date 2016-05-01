//
//  NSNumber+NSLocale.h
//  MulleObjCFoundation
//
//  Created by Nat! on 26.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"


@class NSLocale;


@interface NSNumber (NSLocale)

- (NSString *) descriptionWithLocale:(NSLocale *) locale;

@end
