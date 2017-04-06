//
//  NSArray+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationContainer.h"

#import "NSCoder.h"

#import "_MulleObjCEmptyArray.h"
#import "_MulleObjCConcreteArray.h"
#import "_MulleObjCConcreteArray+Private.h"


@interface NSArray( NSCoder) < NSCoding>
@end

@implementation NSArray( NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSArray class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   [self release];
   if( ! count)
      return( [[_MulleObjCEmptyArray sharedInstance] retain]);

   return( [_MulleObjCConcreteArray _allocWithCapacity:count]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           obj;

   count = (uint32_t) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   for( obj in self)
      [coder encodeObject:obj];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end


@implementation NSMutableArray( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableArray class]);
}

- (void) decodeWithCoder:(NSCoder *) coder
{
}

@end


@implementation _MulleObjCConcreteArray( NSCoder)

#pragma mark -
#pragma mark NSCoder

- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *p;
   id           *sentinel;
   id           *objects;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   assert( self->_count && count);

   objects = _MulleObjCConcreteArrayGetObjects( self);
   p        = objects;
   sentinel = &p[ count];

   while( p < sentinel)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:p];
      ++p;
   }
}

@end

