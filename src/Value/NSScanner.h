//
//  NSScanner.m
//  MulleObjCValueFoundation
//
//  Copyright (c) 2020 Nat! - Mulle kybernetiK.
//  Copyright (c) 2020 Codeon GmbH.
//  All rights reserved.
//
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  Neither the name of Mulle kybernetiK nor the names of its contributors
//  may be used to endorse or promote products derived from this software
//  without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
//  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
//  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
//  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
//  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
//  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
//  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
//  POSSIBILITY OF SUCH DAMAGE.
//

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
@class NSLocale;


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
@property( retain) NSLocale                                      *locale;
@property( getter=caseSensitive,setter=setCaseSensitive:) BOOL   isCaseSensitive;
@property( assign) NSUInteger                                    scanLocation;

+ (instancetype) scannerWithString:(NSString *)string;

- (instancetype) initWithString:(NSString *)string;

// Conflicts by type with +[NSString string], this will be solved eventually
// but not now
- (NSString *) string;

- (BOOL) isAtEnd;


// grab all characters matching charset, intoString: maybe NULL
- (BOOL) scanCharactersFromSet:(NSCharacterSet *) charset
                    intoString:(NSString **) stringp;

// grab all characters not matching charset, intoString: maybe NULL
- (BOOL) scanUpToCharactersFromSet:(NSCharacterSet *)charset
                        intoString:(NSString **)stringp;


/*
 * search for a string, gobbling up all inbetween characters in stringp
 * (except leading characters in charactersToBeSkipped), intoString: maybe NULL
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
