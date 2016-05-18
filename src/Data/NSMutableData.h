/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSMutableData.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSData.h"

#import "MulleObjCFoundationBase.h"


@interface NSData ( NSMutableCopying) < NSMutableCopying>

- (id) mutableCopy;

@end


@interface NSMutableData : NSData < MulleObjCClassCluster>

+ (id) dataWithCapacity:(NSUInteger) aNumItems;
+ (id) dataWithLength:(NSUInteger) length;
- (id) initWithLength:(NSUInteger) length;
- (void) appendData:(NSData *) otherData;

- (void) setData:(NSData *) aData;

@end


@interface NSMutableData( Subclass)

- (id) initWithCapacity:(NSUInteger) capacity;

- (void) appendBytes:(void *) bytes
             length:(NSUInteger) length;
- (void) increaseLengthBy:(NSUInteger) extraLength;

- (void *) mutableBytes;
- (void) resetBytesInRange:(NSRange) range;

- (void) replaceBytesInRange:(NSRange) range
                    withBytes:(void *) bytes;
- (void) replaceBytesInRange:(NSRange) range 
                    withBytes:(void *) replacementBytes 
                       length:(NSUInteger) replacementLength;

- (void) setLength:(NSUInteger) length;

@end


@interface NSMutableData( _Private)

+ (id) _nonZeroedDataWithLength:(NSUInteger) length;
- (id) _initNonZeroedDataWithLength:(NSUInteger) length;
- (void) _setLengthDontZero:(NSUInteger) length;

@end

