//
//  NSDateFactory.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationValue.h"

@class NSTimeZone;


@protocol NSLocalizedDateFactory

- (id) initWithTimeintervalSince1970:(NSTimeInterval) interval
                            timeZone:(NSTimeZone *) timeZone;

@end

