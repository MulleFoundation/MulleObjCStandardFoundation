//
//  NSCalendarDate+PropertyListPrinting.m
//  MulleEOUtil
//
//  Created by Nat! on 18.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSDate+PropertyListPrinting.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationLocale.h"

// std-c and dependencies


NSString      *_MulleObjCPropertyListCanonicalPrintingCalendarFormat =  @"%Y.%m.%d %H:%M:%S:%F";
// always GMT!
NSTimeZone    *_MulleObjCPropertyListCanonicalPrintingTimeZone;


@implementation NSDate( PropertyListPrinting)


- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent
{
   NSString   *s;
   
   s = [self descriptionWithCalendarFormat:_MulleObjCPropertyListCanonicalPrintingCalendarFormat
                                  timeZone:_MulleObjCPropertyListCanonicalPrintingTimeZone
                                    locale:_MulleObjCPropertyListCanonicalPrintingLocale];
   return( [s propertyListUTF8DataWithIndent:indent]);
}

@end
