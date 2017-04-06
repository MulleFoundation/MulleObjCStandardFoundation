//
//  NSString+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationString.h"

#import "NSCoder.h"


@interface NSString (NSCoder) <NSCoding> // invisible NSCoding, is it bad ?
@end


@implementation NSString (NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSString class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   void         *bytes;
   NSUInteger   length;

   bytes = [coder decodeBytesWithReturnedLength:&length];
   return( [self _initWithUTF8Characters:bytes
                                  length:length]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   char         *bytes;
   NSUInteger   length;

   bytes  = [self UTF8String];
   length = [self _UTF8StringLength];
   [coder encodeBytes:bytes
               length:length + 1];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end
