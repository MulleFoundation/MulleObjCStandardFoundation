//
//  NSString+Search.h
//  MulleObjCFoundation
//
//  Created by Nat! on 19.03.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSString.h"


//
// currently this just does literal searches.
// TODO: create a hook for non-literal searches and use a proper unicode
// library for that.
//
@interface NSString (Search)

- (BOOL) isEqualToString:(NSString *) other;

- (NSComparisonResult) compare:(NSString *) other;
- (NSComparisonResult) caseInsensitiveCompare:(NSString *) other;

- (NSRange) rangeOfString:(NSString *) other 
                  options:(NSStringCompareOptions) options;

- (NSRange) rangeOfString:(NSString *) other 
                  options:(NSStringCompareOptions) options
                    range:(NSRange) range;

- (NSRange) rangeOfString:(NSString *) other;

- (BOOL) hasPrefix:(NSString *) prefix;
- (BOOL) hasSuffix:(NSString *) suffix;

- (NSComparisonResult) compare:(id) other
                       options:(NSStringCompareOptions) options 
                         range:(NSRange) range;


// finds occurence
- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options
                              range:(NSRange) range;

- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set
                            options:(NSStringCompareOptions) options;

- (NSRange) rangeOfCharacterFromSet:(NSCharacterSet *) set;


#pragma mark -
#pragma mark mulle additions

//
// finds longest ranges from the start,
// use NSBackwardsSearch to find Suffix
// cheaper than using an inverted set
//
- (NSRange) rangeOfPrefixCharactersFromSet:(NSCharacterSet *) set
                                   options:(NSStringCompareOptions) options
                                     range:(NSRange) range;

@end
