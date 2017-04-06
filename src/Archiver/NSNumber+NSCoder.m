//
//  NSNumber+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationValue.h"

#import "NSCoder.h"

#ifndef MULLE_OBJC_NO_TAGGED_POINTERS

#import "_MulleObjCTaggedPointerIntegerNumber.h"


@interface NSValue (NSCoder) <NSCoding>
@end


@interface _MulleObjCTaggedPointerIntegerNumber( NSCoder) < NSCoding>
@end

@implementation _MulleObjCTaggedPointerIntegerNumber( NSCoder)

#pragma mark -
#pragma mark NSCoding

- (void) encodeWithCoder:(NSCoder *) coder
{
   char        *type;
   NSInteger   value;

   value = _MulleObjCTaggedPointerIntegerNumberGetIntegerValue( self);

   type = @encode( NSInteger);
   [coder encodeBytes:type
               length:sizeof( @encode( NSInteger))];
   [coder encodeValueOfObjCType:type
                             at:&value];
}

@end

#endif
