//
//  NSDate+NSLocale.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSDate+NSLocale.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "NSLocale.h"
#import "NSFormatter+NSLocale.h"

// std-c and dependencies


@implementation NSDate (NSLocale)

- (NSString *) descriptionWithLocale:(NSLocale *) locale
{
   NSDateFormatter    *formatter;

   // if this is too slow, but a default formatter into class vars
   
   formatter = [[NSDateFormatter new] autorelease];
   [formatter setLocale:locale];
   return( [formatter stringFromDate:self]);
}

@end
