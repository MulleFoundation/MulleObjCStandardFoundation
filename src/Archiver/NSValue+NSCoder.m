//
//  NSValue+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "NSValue+NSCoder.h"

#import "NSCoder.h"

#import "_MulleObjCConcreteValue.h"
#import "_MulleObjCConcreteValue-Private.h"


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
- (instancetype) initWithCoder:(NSCoder *) coder
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


#ifndef MULLE_OBJC_NO_TAGGED_POINTERS

#import "_MulleObjCTaggedPointerIntegerNumber.h"


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

