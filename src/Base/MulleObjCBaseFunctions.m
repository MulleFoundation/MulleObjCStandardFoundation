//
//  MullObjCBaseFunctions.c
//  MulleObjCFoundation
//
//  Created by Nat! on 28.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCBaseFunctions.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and other dependencies


NSString   *NSStringFromRange( NSRange range)
{
   return( [NSString stringWithFormat:@"%lu, %lu", range.location, range.length]);
}
