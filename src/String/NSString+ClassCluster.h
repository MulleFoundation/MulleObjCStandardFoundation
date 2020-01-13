//
//  NSString+ClassCluster.h
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

#import "NSString.h"


@interface NSString( ClassCluster)

- (instancetype) initWithCharacters:(unichar *) s
                             length:(NSUInteger) len;
- (instancetype) initWithCharactersNoCopy:(unichar *) chars
                                   length:(NSUInteger) length
                             freeWhenDone:(BOOL) flag;

- (instancetype) initWithUTF8String:(char *) s;


// mulle additions

- (instancetype) mulleInitWithUTF8Characters:(mulle_utf8_t *) s
                                      length:(NSUInteger) len;

// lenient, if UTF8 is corrupt returns nil and doesn't raise
- (instancetype) mulleInitOrNilWithUTF8Characters:(mulle_utf8_t *) s
                                           length:(NSUInteger) len;

- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                            length:(NSUInteger) length
                                      freeWhenDone:(BOOL) flag;

// use allocator: NULL for static text only
- (instancetype) mulleInitWithCharactersNoCopy:(unichar *) s
                                        length:(NSUInteger) length
                                     allocator:(struct mulle_allocator *) allocator;

// use allocator: NULL for static text only
- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                            length:(NSUInteger) lengt
                                         allocator:(struct mulle_allocator *) allocator;

- (instancetype) mulleInitWithUTF8CharactersNoCopy:(mulle_utf8_t *) s
                                            length:(NSUInteger) length
                                     sharingObject:(id) object;

- (instancetype) mulleInitWithCharactersNoCopy:(unichar *) s
                                        length:(NSUInteger) length
                                 sharingObject:(id) object;

@end

NSString  *MulleObjCNewASCIIStringWithASCIICharacters( char *s,
                                                       NSUInteger length);
NSString  *MulleObjCNewASCIIStringWithUTF32Characters( mulle_utf32_t *s,
                                                       NSUInteger length);

