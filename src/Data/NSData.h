/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSData.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import <MulleObjC/MulleObjC.h>



enum {
   NSDataSearchBackwards = 1UL << 0,
   NSDataSearchAnchored = 1UL << 1
};


@interface NSData : NSObject < MulleObjCClassCluster, NSCopying, NSCoding>
{
}

+ (id) dataWithBytes:(void *) bytes
              length:(NSUInteger) length;
+ (id) dataWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length;
+ (id) dataWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
              freeWhenDone:(BOOL) flag;
+ (id) dataWithData:(NSData *) other;
+ (id) data;

- (NSUInteger) hash;
- (BOOL) isEqual:(id) other;

- (void) getBytes:(void *) bytes;
- (void) getBytes:(void *) bytes
           length:(NSUInteger) length;
- (void) getBytes:(void *) bytes
            range:(NSRange) range;
- (BOOL) isEqualToData:(NSData *) other;
- (id) subdataWithRange:(NSRange) range;
- (NSRange) rangeOfData:(id) other
                options:(NSUInteger) options
                  range:(NSRange) range;

@end

@interface NSData ( MulleObjCDataPlaceholder)

- (id) initWithBytes:(void *) bytes
              length:(NSUInteger) length
                copy:(BOOL) copy
        freeWhenDone:(BOOL) freeWhenDone
          bytesAreVM:(BOOL) bytesAreVM;
- (id) initWithBytes:(void *) bytes
              length:(NSUInteger) length;
- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length;
- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
                 allocator:(struct mulle_allocator *) allocator;
- (id) initWithBytesNoCopy:(void *) bytes
                    length:(NSUInteger) length
              freeWhenDone:(BOOL) flag;

- (id) initWithData:(NSData *) other;

@end


@interface NSData ( MulleObjCSubclasses)

- (NSUInteger) length;
- (void *) bytes;

@end


