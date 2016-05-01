//
//  NSString+PropertyListPrinting.h
//  MulleEOUtil
//
//  Created by Nat! on 14.08.09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "NSObject+PropertyListPrinting.h"


@interface NSString  (PropertyListPrinting)

- (NSData *) propertyListUTF8DataWithIndent:(unsigned int) indent;
                                          
@end
