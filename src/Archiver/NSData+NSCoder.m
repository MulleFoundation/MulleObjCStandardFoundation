//
//  NSData+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationData.h"

#import "NSCoder.h"


@interface NSData (NSCoder) <NSCoding>
@end


@implementation NSData( NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSData class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   void         *bytes;
   NSUInteger   length;

   bytes = [coder decodeBytesWithReturnedLength:&length];
   return( [self initWithBytes:bytes
                        length:length]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeBytes:[self bytes]
               length:[self length]];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end


@implementation NSMutableData( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableData class]);
}

@end
