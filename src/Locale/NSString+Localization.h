/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSString+Localization.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "MulleObjCFoundationString.h"


@class NSLocale;


@interface NSString( NSLocale)

+ (id) stringWithFormat:(NSString *) format 
                 locale:(NSLocale *) locale;

- (id) initWithFormat:(NSString *) format
               locale:(NSLocale *) locale, ...;
               
+ (id) localizedStringWithFormat:(NSString *) format;

- (NSComparisonResult) localizedCompare:(NSString *) other;
- (NSComparisonResult) localizedCaseInsensitiveCompare:(NSString *) other;
- (NSComparisonResult) localizedStandardCompare:(NSString *) other;
- (NSComparisonResult) compare:(NSString *) other
                       options:(NSUInteger) locale
                         range:(NSRange) range
                        locale:(NSLocale *) locale;

- (NSRange) rangeOfString:(NSString *) other
                  options:(NSStringCompareOptions) options
                    range:(NSRange) range
                   locale:(NSLocale *) locale;
                   
- (id) initWithFormat:(NSString *) format 
              locale:(NSLocale *) locale
           arguments:(va_list) argList;

- (id) stringByFoldingWithOptions:(NSUInteger) options
                           locale:(id) locale;
                           
@end
