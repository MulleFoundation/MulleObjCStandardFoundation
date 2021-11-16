//
//  NSString+Escaping.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2016 Nat! - Mulle kybernetiK.
//  Copyright (c) 2016 Codeon GmbH.
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

#import "import.h"


@class NSCharacterSet;


@interface NSString (Escaping)

- (NSString *) stringByAddingPercentEncodingWithAllowedCharacters:(NSCharacterSet *) allowedCharacters;

- (NSString *) stringByRemovingPercentEncoding;

// escaped C-string with " " added, does not do octal escapes though (yet)
- (NSString *) mulleQuotedString;
- (NSString *) mulleUnquotedString;

// as above but no " " added
- (NSString *) mulleEscapedString;
- (NSString *) mulleUnescapedString;

- (NSString *) mulleQuotedDescriptionIfNeeded;

// useful for converting non-printables to '.' for example
- (NSString *) mulleStringByReplacingCharactersInSet:(NSCharacterSet *) s
                                       withCharacter:(unichar) c;
- (NSString *) mulleStringByReplacingPercentEscapesWithDisallowedCharacters:(NSCharacterSet *) disallowedCharacters;

@end


//
// TODO: move to C library
//

// make dst at least 4 * src.length for octal escape worst case
char   *MulleUTF8StringEscape( char *src, NSUInteger length, char *dst);

// make dst at least src.length for no-escape worst case
char   *MulleUTF8StringUnescape( char *src, NSUInteger length, char *dst);


// underscore because of struct mulle_utf8data
struct mulle_utf8data  *_MulleReplacePercentEscape( struct mulle_utf8data *src,
                                                    NSCharacterSet *disallowedCharacters);
NSString  *MulleObjCStringByReplacingPercentEscapes( NSString *self,
                                                     NSCharacterSet *disallowedCharacters);