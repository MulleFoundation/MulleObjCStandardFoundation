//
//  NSString+Escaping.h
//  MulleObjCFoundation
//
//  Created by Nat! on 24.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString+NSData.h"


@class NSCharacterSet;


@interface NSString (Escaping)

- (NSString *) stringByAddingPercentEscapesUsingEncoding:(NSStringEncoding) encoding;
- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters;

- (NSString *) stringByReplacingPercentEscapesUsingEncoding:(NSStringEncoding) encoding;
- (NSString *) stringByRemovingPercentEncoding;

@end
