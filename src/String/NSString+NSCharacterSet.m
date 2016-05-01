//
//  NSString+NSCharacterSet.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+NSCharacterSet.h"

// other files in this library
#import "NSCharacterSet.h"
#import "NSString+Search.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies

@implementation NSString (NSCharacterSet)

- (NSString *) stringByTrimmingCharactersInSet:(NSCharacterSet *) set
{
   NSRange   startRange;
   NSRange   endRange;
   NSRange   range;
   NSRange   originalRange;

   originalRange = NSMakeRange( 0, [self length]);
   
   startRange = [self rangeOfPrefixCharactersFromSet:set
                                             options:0
                                               range:originalRange];
   endRange   = [self rangeOfPrefixCharactersFromSet:set
                                             options:NSBackwardsSearch
                                                range:originalRange];
   
   if( startRange.length)
   {
      range.location = startRange.length;
      if( endRange.length)
         range.length = endRange.location;
      else
         range.length = originalRange.length - range.location;
   }
   else
   {
      if( ! endRange.length)
         return( self);

      range.location = 0;
      range.length   = endRange.location;
   }
   return( [self substringWithRange:range]);
}

@end
