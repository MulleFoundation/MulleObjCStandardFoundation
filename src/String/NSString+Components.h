//
//  NSString+Components.h
//  MulleObjCStandardFoundation
//
//  Copyright (c) 2006 Nat! - Mulle kybernetiK.
//  Copyright (c) 2006 Codeon GmbH.
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


// useful for moderately sized strings < 4K i guess
// and short separator strings
// for really large strings use some smarter algorithm or one that can exploit
// long seperator strings. This is used for keyPath decoding
//
@class NSArray;
@class NSCharacterSet;


@interface NSString ( Components)

- (NSArray *) componentsSeparatedByString:(NSString *) s;
- (NSArray *) componentsSeparatedByCharactersInSet:(NSCharacterSet *) separators;

#pragma mark -
#pragma mark mulle additions

- (NSMutableArray *) mulleMutableComponentsSeparatedByString:(NSString *) s;
- (NSMutableArray *) mulleMutableComponentsSeparatedByCharactersInSet:(NSCharacterSet *) separators;

// these two will return nil, if no separator is found
- (NSArray *) _componentsSeparatedByString:(NSString *) separator;
- (NSArray *) _componentsSeparatedByCharacterSet:(NSCharacterSet *) separators;

- (NSString *) mulleStringBySimplifyingComponentsSeparatedByString:(NSString *) separator
                                                      simplifyDots:(BOOL) simplifyDots;
@end

// this returns nil, if no separator is found
NSArray  *MulleObjCComponentsSeparatedByString( NSString *self, NSString *separator);
NSArray  *MulleObjCComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators);
NSMutableArray  *MulleObjCMutableComponentsSeparatedByString( NSString *self, NSString *separator);
NSMutableArray  *MulleObjCMutableComponentsSeparatedByCharacterSet( NSString *self, NSCharacterSet *separators);
