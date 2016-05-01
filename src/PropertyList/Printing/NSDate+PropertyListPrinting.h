/*
 *  NSArray+PropertyListPrinting.h
 *  MulleEOUtil
 *  $Id$ 
 *  Created by Nat! on 10.08.09.
 *  Copyright 2009 Mulle kybernetiK. All rights reserved.
 *
 *  $Log$
 *
 */
#import "NSObject+PropertyListPrinting.h"


@class NSTimeZone;


extern NSString      *_MulleObjCPropertyListCanonicalPrintingCalendarFormat;
extern NSTimeZone    *_MulleObjCPropertyListCanonicalPrintingTimeZone;

@interface NSDate ( PropertyListPrinting)

- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent;

@end
