//
//  NSString+NSData.h
//  MulleObjCFoundation
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

@class NSData;


// maybe more later. should ensure that the enums have same numeric values as
// in AppleFoundation
//

enum
{
   NSASCIIStringEncoding             = 1,
   NSNEXTSTEPStringEncoding          = 2,    // no support
   NSJapaneseEUCStringEncoding       = 3,    // no support
   NSUTF8StringEncoding              = 4,
   NSISOLatin1StringEncoding         = 5,    // no support
   NSSymbolStringEncoding            = 6,    // no support
   NSNonLossyASCIIStringEncoding     = 7,    // no support (stooopid ?)
   NSShiftJISStringEncoding          = 8,    // no support
   NSISOLatin2StringEncoding         = 9,    // no support
   NSUTF16StringEncoding             = 10,
   NSWindowsCP1251StringEncoding     = 11,    // no support
   NSWindowsCP1252StringEncoding     = 12,    // no support
   NSWindowsCP1253StringEncoding     = 13,    // no support
   NSWindowsCP1254StringEncoding     = 14,    // no support
   NSWindowsCP1250StringEncoding     = 15,    // no support
   NSISO2022JPStringEncoding         = 21,    // no support
   NSMacOSRomanStringEncoding        = 30,    // no support
};

// too big for enums
#define NSUTF16BigEndianStringEncoding       0x90000100
#define NSUTF16LittleEndianStringEncoding    0x94000100

#define NSUTF32StringEncoding                0x8c000100
#define NSUTF32BigEndianStringEncoding       0x98000100
#define NSUTF32LittleEndianStringEncoding    0x9c000100

#define NSUnicodeStringEncoding              NSUTF32StringEncoding // different(!)


typedef NSUInteger   NSStringEncoding;


enum
{
   NSStringEncodingConversionAllowLossy             = 1,
   NSStringEncodingConversionExternalRepresentation = 2
};

typedef NSUInteger   NSStringEncodingConversionOptions;


@interface NSString (NSData)

- (NSStringEncoding) fastestEncoding;
- (NSStringEncoding) smallestEncoding;

- (BOOL) canBeConvertedToEncoding:(NSStringEncoding) encoding;

- (NSData *) dataUsingEncoding:(NSStringEncoding) encoding;

- (id) initWithData:(NSData *) data
           encoding:(NSUInteger) encoding;

- (instancetype) initWithBytes:(void *) bytes
                        length:(NSUInteger) length
                      encoding:(NSStringEncoding) encoding;

// this method is a lie, it will copy
// use initWithCharactersNoCopy:
// also your bytes will be freed immediately, when freeWhenDone is YES
- (instancetype) initWithBytesNoCopy:(void *) bytes
                              length:(NSUInteger) length
                            encoding:(NSStringEncoding) encoding
                        freeWhenDone:(BOOL) flag;


// the generic routine is slow
- (BOOL) getBytes:(void *) buffer
        maxLength:(NSUInteger) maxLength
       usedLength:(NSUInteger *) usedLength
         encoding:(NSStringEncoding) encoding
          options:(NSStringEncodingConversionOptions) options
            range:(NSRange) range
   remainingRange:(NSRangePointer) leftover;


#pragma mark -
#pragma mark mulle additions

- (instancetype) _initWithBytesNoCopy:(void *) bytes
                               length:(NSUInteger) length
                             encoding:(NSStringEncoding) encoding
                        sharingObject:(id) owner;

- (instancetype) _initWithDataNoCopy:(NSData *) s
                            encoding:(NSStringEncoding) encoding;

@end
