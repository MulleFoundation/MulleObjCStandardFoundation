//
//  NSDate+NSCalendarDate.h
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 10.05.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"


@class NSCalendarDate;
@class NSTimeZone;


@interface NSDate (NSCalendarDate)

- (NSCalendarDate *) calendarDateWithTimeZone:(NSTimeZone *) tz;

// deprecated and ignores calendarFormat
- (NSCalendarDate *) dateWithCalendarFormat:(NSString *) format
                                   timeZone:(NSTimeZone *) aTimeZone;
@end
