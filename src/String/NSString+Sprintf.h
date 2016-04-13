//
//  NSString+Sprintf.h
//  MulleObjCFoundation
//
//  Created by Nat! on 09.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


@interface NSString (Sprintf)

+ (id) stringWithFormat:(NSString *) format
              arguments:(mulle_vararg_list) arguments;
              
+ (id) stringWithFormat:(NSString *) format
                va_list:(va_list) args;

+ (id) stringWithFormat:(NSString *) format, ...;

- (NSString *) stringByAppendingFormat:(NSString *) format, ...;

- (id) initWithFormat:(NSString *) format
            arguments:(mulle_vararg_list) arguments;
- (id) initWithFormat:(NSString *) format
              va_list:(va_list) va_list;

@end
