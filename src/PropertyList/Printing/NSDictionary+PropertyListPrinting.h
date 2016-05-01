/*
 *  NSDictionary+PropertyListPrinting.h
 *  MulleObjCEOUtil
 *  $Id$ 
 *  Created by Nat! on 10.08.09.
 *  Copyright 2009 MulleObjC kybernetiK. All rights reserved.
 *
 *  $Log$
 *
 */
#import "NSObject+PropertyListPrinting.h"


@interface NSDictionary( PropertyListPrinting)

- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(unsigned int) indent;

@end
