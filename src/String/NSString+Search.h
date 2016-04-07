//
//  NSString+NSSearch.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


@interface NSString (NSSearch)

- (BOOL) isEqualToString:(NSString *) other;

- (NSComparisonResult) compare:(NSString *) other;
- (NSComparisonResult) caseInsensitiveCompare:(NSString *) other;

- (NSRange) rangeOfString:(NSString *) other 
                  options:(NSStringCompareOptions) options;

- (NSRange) rangeOfString:(NSString *) other 
                  options:(NSStringCompareOptions) options
                    range:(NSRange) aRange;

- (NSRange) rangeOfString:(NSString *) other;

- (BOOL) hasPrefix:(NSString *) prefix;
- (BOOL) hasSuffix:(NSString *) suffix;

- (NSComparisonResult) compare:(id) other
                       options:(NSStringCompareOptions) options 
                         range:(NSRange) aRange;

@end
