//
//  NSValue+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationValue.h"

#import "NSCoder.h"

#import "_MulleObjCConcreteValue.h"
#import "_MulleObjCConcreteValue+Private.h"


@interface NSValue (NSCoder) <NSCoding>
@end


@implementation NSValue (NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSValue class]);
}


// it is assumed, that NSValue and subclasses store their
// "value" at the first instance variable of type
// [self objCType]. If not override in your subclass
//
- (void) encodeWithCoder:(NSCoder *) coder
{
   char  *type;

   type = [self objCType];
   [coder encodeBytes:type
               length:strlen( type) + 1];
   [coder encodeValueOfObjCType:type
                             at:self];
}


// if this is a bottleneck, improve in subclasses
- (id) initWithCoder:(NSCoder *) coder
{
   char         *type;
   NSUInteger   size;

   type = [coder decodeBytesWithReturnedLength:NULL];

   NSGetSizeAndAlignment( type, &size, NULL);
   {
      uint8_t   buf[ size];

      [coder decodeValueOfObjCType:type
                              at:buf];

      return( [self initWithBytes:buf
                        objCType:type]);
   }
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end



@implementation _MulleObjCConcreteValue( NSCoder)

- (void) encodeWithCoder:(NSCoder *) coder
{
   char  *type;

   type = NULL;
   [coder encodeValueOfObjCType:@encode( char *)
                             at:&type];
   [coder encodeValueOfObjCType:type
                             at:_MulleObjCConcreteValueBytes( self)];
}

@end

