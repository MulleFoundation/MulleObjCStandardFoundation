//
//  NSString.h
//  MulleObjCFoundation
//
//  Copyright (c) 2011 Nat! - Mulle kybernetiK.
//  Copyright (c) 2011 Codeon GmbH.
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
#import "MulleObjCFoundationBase.h"

#import "NSCharacterSet.h"

#import <mulle_vararg/mulle_vararg.h>


enum
{
   NSCaseInsensitiveSearch = 0x001,
   NSLiteralSearch         = 0x002,
   NSBackwardsSearch       = 0x004,
   NSAnchoredSearch        = 0x008,
   NSNumericSearch         = 0x040
};

typedef NSUInteger   NSStringCompareOptions;



//
// NSString is outside of NSObject, the most fundamental class
// since its totally pervasive in all other classes.
// The implementation in MulleObjCFoundation is slightly schizophrenic.
// On the character level anything below UTF-32 is just misery.
// But UTF-8 is basically what is being used (for I/O).
//
// The MulleObjCFoundation deals with UTF32 and UTF8.
// UTF-16 is treated just an optimized storage medium for UTF strings.
//
// A CString is a string with a zero terminator in the C locale,
// this particular library does not deal with locales, so the concept
// is postponed until the POSIX is introduced. (Truth be told, c locales suck)
//
// To support unichar somewhat efficiently
//
//    o make unichar UTF-32
//    o store strings in three formats
//        1. ASCII (7 bit)
//        2. UTF-16 (w/o surrogate pairs)
//        3. UTF-32, everything else
//    o strings that are not ASCII, store their UTF8 representation when
//      needed.
//
// As an external exchange format UTF8 is the law, forget the others.
//

//
// when dealing with the filesystem (open/stat) use -fileSystemRepresentation
// defined by a layer upwards of MulleObjCFoundation
// when interfacing with the OS (log messages) or C use cString
// in all other cases use UTF8String
//

@interface NSString : NSObject < MulleObjCClassCluster, NSCopying>
{
}

+ (instancetype) string;
+ (instancetype) stringWithString:(NSString *) other;

- (NSString *) description;

- (NSString *) substringWithRange:(NSRange) range;
- (NSString *) substringFromIndex:(NSUInteger) index;
- (NSString *) substringToIndex:(NSUInteger) index;

- (double) doubleValue;
- (float) floatValue;
- (int) intValue;
- (long long) longLongValue;
- (NSInteger) integerValue;
- (BOOL) boolValue;


//
// UTF32
//
+ (instancetype) stringWithCharacters:(unichar *) s
                     length:(NSUInteger) len;

- (void) getCharacters:(unichar *) buffer;

//
// UTF8
// keep "old" UTF8Strings methods using char *
+ (instancetype) stringWithUTF8String:(char *) s;
+ (instancetype) _stringWithUTF8Characters:(mulle_utf8_t *) s
                         length:(NSUInteger) len;

// characters are not zero terminated
- (void) _getUTF8Characters:(mulle_utf8_t *) buf;

+ (BOOL) _areValidUTF8Characters:(mulle_utf8_t *) buffer
                          length:(NSUInteger) length;

// strings are zero terminated, zero stored in
// buf[ size - 1]
//
- (NSUInteger) _getUTF8String:(mulle_utf8_t *) buf
                  bufferSize:(NSUInteger) size;
- (void) _getUTF8String:(mulle_utf8_t *) buf;

- (char *) UTF8String;

- (NSString *) uppercaseString;
- (NSString *) lowercaseString;
- (NSString *) capitalizedString;

@end


@interface NSString( MulleAdditions)

- (NSUInteger) _UTF8StringLength;
+ (instancetype) _stringWithCharactersNoCopy:(unichar *) s
                            length:(NSUInteger) len
                         allocator:(struct mulle_allocator *) allocator;
+ (instancetype) _stringWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                length:(NSUInteger) len
                             allocator:(struct mulle_allocator *) allocator;

@end


@interface NSString( Subclasses)

- (unichar) characterAtIndex:(NSUInteger) index;
- (NSUInteger) length;

- (void) getCharacters:(unichar *) buffer
                 range:(NSRange) range;
- (void) _getUTF8Characters:(mulle_utf8_t *) buffer
                  maxLength:(NSUInteger) length;
@end


@interface NSString ( Todo)

- (NSString *) stringByAppendingString:(NSString *) other;

- (instancetype) stringByPaddingToLength:(NSUInteger) length
                              withString:(NSString *) other
                         startingAtIndex:(NSUInteger) index;

- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement
                                            options:(NSUInteger) options
                                              range:(NSRange) range;

- (NSString *) stringByReplacingOccurrencesOfString:(NSString *) search
                                         withString:(NSString *) replacement;

- (NSString *) stringByReplacingCharactersInRange:(NSRange) range
                                       withString:(NSString *) replacement;

@end


static inline NSRange   MulleObjCGetHashStringRange(NSUInteger length)
{
   return( MulleObjCGetHashBytesRange( length));
}


static inline NSUInteger   MulleObjCStringHash( mulle_utf8_t *buf, NSUInteger length)
{
   return( MulleObjCBytesPartialHash( buf, length));
}
