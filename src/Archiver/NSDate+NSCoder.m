//
//  NSDate+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSDate+NSCoder.h"

#import "NSCoder.h"



@implementation NSDate( NSCoder)

# pragma mark -
# pragma mark NSCoding

- (instancetype) initWithCoder:(NSCoder *) coder
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
