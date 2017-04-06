//
//  NSCalendarDate+NSDateFormatter.h
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSCalendarDate.h"


@class NSLocale;
@class NSString;


@interface NSCalendarDate( NSDateFormatter)

+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(NSLocale *) locale;
+ (instancetype) dateWithString:(NSString *) s
                 calendarFormat:(NSString *) format;
- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format
                         locale:(id) locale;
- (instancetype) initWithString:(NSString *) s
                 calendarFormat:(NSString *) format;
- (instancetype) initWithString:(NSString *) s;

@end
