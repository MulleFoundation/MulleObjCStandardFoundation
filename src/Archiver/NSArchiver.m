//
//  NSArchiver.m
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 17.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSArchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"

// other libraries of MulleObjCFoundation

// std-c and dependencies


@interface MulleObjCArchiver ( Private)

- (void) _appendBytes:(void *) bytes
               length:(NSUInteger) size;

- (void *) _encodeValueOfObjCType:(char *) type
                               at:(void *) p;

@end


@implementation NSArchiver

# pragma mark -
# pragma mark NSCoder

- (void) encodeValueOfObjCType:(char *) type
                            at:(void *) p
{
   [self _encodeValueOfObjCType:type
                             at:p];
}


- (void) encodeBytes:(void *) bytes
              length:(NSUInteger) len
{
   [self _appendBytes:bytes
               length:len];
}

@end
