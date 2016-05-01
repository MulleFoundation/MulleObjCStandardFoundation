//
//  NSNumber+PropertyListPrinting.m
//  MulleEOUtil
//
//  Created by Nat! on 19.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+PropertyListPrinting.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationLocale.h"

// std-c and dependencies


@implementation NSNumber ( PropertyListPrinting)

- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent
{
   NSString   *s;

   s = [self descriptionWithLocale:_MulleObjCPropertyListCanonicalPrintingLocale];
   return( [s propertyListUTF8DataWithIndent:indent]);
}

@end
