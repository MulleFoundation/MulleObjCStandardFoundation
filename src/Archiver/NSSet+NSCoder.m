//
//  NSSet+NSCoder.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//
#import "MulleObjCFoundationContainer.h"

#import "NSCoder.h"

#import "_MulleObjCConcreteSet.h"
#import "_MulleObjCConcreteMutableSet.h"


@interface NSSet( NSCoder) < NSCoding>
@end


@implementation NSSet (NSCoder)

#pragma mark -
#pragma mark NSCoder

- (Class) classForCoder
{
   return( [NSSet class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   return( [_MulleObjCConcreteSet _allocWithCapacity:count]);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger     count;
   NSEnumerator   *rover;
   id             obj;

   count = (NSUInteger) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   rover = [self objectEnumerator];
   while( obj = [rover nextObject])
      [coder encodeObject:obj];
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *objects;
   id           *p;
   id           *sentinel;
   size_t       size;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   if( ! count)
      return;

   size    = count * sizeof( id);
   objects = MulleObjCObjectAllocateNonZeroedMemory( self, size);

   p        = objects;
   sentinel = &p[ count];
   while( p < sentinel)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:p];
      ++p;
   }

   [(_MulleObjCConcreteSet *) self _initWithObjects:objects
                                              count:count];
   MulleObjCMakeObjectsPerformRelease( objects, count);
   MulleObjCObjectDeallocateMemory( self, objects);
}

@end



@implementation NSMutableSet (NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSMutableSet class]);
}


- (id) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   return( (id) [_MulleObjCConcreteMutableSet _allocWithCapacity:count]);
}

@end



