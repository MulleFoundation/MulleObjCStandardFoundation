//
//  NSDate+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"

#import "NSCoder.h"


@interface NSDate (NSCoder) <NSCoding>
@end


@implementation NSDate( NSCoder)

# pragma mark -
# pragma mark NSCoding

- (id) initWithCoder:(NSCoder *) coder
{
   NSTimeInterval   value;

   [coder decodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&value];
   return( [self initWithTimeIntervalSinceReferenceDate:value]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   [coder encodeValueOfObjCType:@encode( NSTimeInterval)
                             at:&_interval];
}

@end
