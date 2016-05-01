//
//  NSDictionary+NSLocale.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSDictionary+NSLocale.h"


@implementation NSDictionary (NSLocale)


- (NSString *) descriptionWithLocale:(id) locale
                              indent:(NSUInteger) level
{
   return( [self description]);
}


- (NSString *) descriptionWithLocale:(NSLocale *) locale
{
   return( [self description]);
}

@end
