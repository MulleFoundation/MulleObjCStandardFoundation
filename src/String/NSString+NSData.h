//
//  NSString+NSData.h
//  MulleObjCFoundation
//
//  Created by Nat! on 25.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
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
   
   NSUTF16BigEndianStringEncoding    = 0x90000100,
   NSUTF16LittleEndianStringEncoding = 0x94000100,
   
   NSUTF32StringEncoding             = 0x8c000100,
   NSUTF32BigEndianStringEncoding    = 0x98000100,
   NSUTF32LittleEndianStringEncoding = 0x9c000100,

   NSUnicodeStringEncoding           = NSUTF32StringEncoding  // different(!)
};

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
