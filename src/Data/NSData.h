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



@interface NSData : NSObject
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
- (BOOL) isEqualToData:(id) other;
- (id) subdataWithRange:(NSRange) range;
- (NSRange) rangeOfData:(id) other
                options:(NSUInteger) options
                  range:(NSRange) range;

@end

@interface NSData ( _NSDataPlaceholder)

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
              freeWhenDone:(BOOL) flag;
- (id) initWithData:(NSData *) other;

@end


@interface NSData ( _NSSubclasses)

- (NSUInteger) length;
- (void *) bytes;
@end



//
//- (id) initWithContentsOfFile:(id) arg1;
//- (id) initWithContentsOfFile:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//- (id) initWithContentsOfURL:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//- (id) initWithContentsOfURL:(id) arg1;
//- (id) initWithContentsOfMappedFile:(id) arg1;
//- (id) initWithContentsOfMappedFile:(id) arg1 error:(id *) arg2;
//- (id) initWithContentsOfFile:(id) arg1 error:(id *) arg2;
//+ (id) dataWithContentsOfFile:(id) arg1;
//+ (id) dataWithContentsOfURL:(id) arg1;
//+ (id) dataWithContentsOfMappedFile:(id) arg1;
//+ (id) dataWithContentsOfFile:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//+ (id) dataWithContentsOfURL:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//- (BOOL) writeToFile:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//- (BOOL) writeToURL:(id) arg1 options:(NSUInteger) arg2 error:(id *) arg3;
//- (BOOL) writeToFile:(id) arg1 atomically:(BOOL) arg2 error:(id *) arg3;
//- (BOOL) writeToFile:(id) arg1 atomically:(BOOL) arg2;
//- (BOOL) writeToURL:(id) arg1 atomically:(BOOL) arg2;
//- (id) description;
//- (void) encodeWithCoder:(id) arg1;
//- (id) initWithCoder:(id) arg1;
//- (Class) classForCoder;
//- (id) description;

