//
//  NSUnarchiver.m
//  MulleObjCPosixFoundation
//
//  Created by Nat! on 18.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//

#import "NSUnarchiver.h"

// other files in this library
#import "MulleObjCArchiver+Private.h"
#include "mulle_buffer_archiver.h"

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationData.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@interface MulleObjCUnarchiver ( Private)

- (void *) _decodeBytesForKey:(NSString *) key
               returnedLength:(NSUInteger *) len_p;

- (void *) _decodeValueOfObjCType:(char *) type
                               at:(void *) p;

@end


@implementation NSUnarchiver

- (void) decodeValueOfObjCType:(char *) type
                            at:(void *) p
{
   [self _decodeValueOfObjCType:type
                             at:p];
}


- (void *) decodeBytesForKey:(NSString *) key
              returnedLength:(NSUInteger *) len_p
{
   return( [self _decodeBytesForKey:key
                     returnedLength:len_p]);
}

@end
