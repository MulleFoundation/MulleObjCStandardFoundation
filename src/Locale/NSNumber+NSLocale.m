//
//  NSNumber+NSLocale.m
//  MulleObjCFoundation
//
//  Created by Nat! on 26.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSNumber+NSLocale.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "NSLocale.h"
#import "NSFormatter+NSLocale.h"

// std-c and dependencies


@implementation NSNumber (NSLocale)

- (NSString *) descriptionWithLocale:(NSLocale *) locale
{
   NSNumberFormatter    *formatter;

   // if this is too slow, but a default formatter into class vars
   
   formatter = [[NSNumberFormatter new] autorelease];
   [formatter setLocale:locale];
   return( [formatter stringFromNumber:self]);
}

@end
