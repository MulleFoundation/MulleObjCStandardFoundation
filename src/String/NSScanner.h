/* Copyright (c) 2006-2007 Christopher J. W. Lloyd

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE. */

#import "import.h"

@class NSDictionary,NSCharacterSet;
@class NSString;


//
// NSScanner is a tokenizer. Where you use strtok in C, you can use
// NSScanners scanCharactersFromSet:intoString:
//
@interface NSScanner : NSObject <NSCopying>
{
   NSString     *_string;
   NSUInteger   _location;
   NSUInteger   _length;

@private
   IMP          _impAtIndex;
   IMP          _impIsMember;
}

@property( retain) NSCharacterSet                                *charactersToBeSkipped;
@property( retain) NSDictionary                                  *locale;
@property( getter=caseSensitive,setter=setCaseSensitive:) BOOL   isCaseSensitive;
@property() NSUInteger                                           scanLocation;

+ (instancetype) scannerWithString:(NSString *)string;
//+localizedScannerWithString:(NSString *)string;

- (instancetype) initWithString:(NSString *)string;
- (NSString *) string;

- (BOOL) isAtEnd;


// grab all characters matching charset
- (BOOL) scanCharactersFromSet:(NSCharacterSet *) charset
                    intoString:(NSString **) stringp;

// grab all characters not matching charset
- (BOOL) scanUpToCharactersFromSet:(NSCharacterSet *)charset
                        intoString:(NSString **)stringp;


/*
 * search for a string, gobbling up all inbetween characters in stringp
 * (except leading characters in charactersToBeSkipped)
 */
- (BOOL) scanUpToString:(NSString *) string
             intoString:(NSString **) stringp;

/*
 * rarely useful to set intoString: to anything else than NULL
 */
- (BOOL) scanString:(NSString *) string
         intoString:(NSString **) stringp;


/* DONT USE THESE, THEY ARE PROBABLY BROKEN */

- (BOOL) scanInt:(int *)valuep;
- (BOOL) scanInteger:(NSInteger *)valuep;
- (BOOL) scanLongLong:(long long *)valuep;
- (BOOL) scanFloat:(float *)valuep;
- (BOOL) scanDouble:(double *)valuep;
//-(BOOL)scanDecimal:(NSDecimal *)valuep;
- (BOOL) scanHexInt:(unsigned *)valuep;

@end
