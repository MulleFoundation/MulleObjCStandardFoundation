//
//  NSDictionary+NSCoder.m
//  MulleObjCStandardFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "NSDictionary+NSCoder.h"

#import "NSCoder.h"

#import "_MulleObjCConcreteDictionary.h"


@implementation NSDictionary( NSCoder)

#pragma mark -
#pragma mark NSCoding

- (Class) classForCoder
{
   return( [NSDictionary class]);
}


- (instancetype) initWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           old;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];
   old  = self;
   self = [_MulleObjCConcreteDictionary _allocWithCapacity:count];
   [old release];

   return( self);
}


- (void) decodeWithCoder:(NSCoder *) coder
{
   NSUInteger   count;
   id           *keys;
   id           *values;
   id           *p;
   id           *q;
   id           *sentinel;
   size_t       size;

   [coder decodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   size   = count * sizeof( id) * 2;
   keys   = MulleObjCObjectAllocateNonZeroedMemory( self, size);
   values = &keys[ count];

   p        = keys;
   q        = values;
   sentinel = &p[ count];
   while( p < sentinel)
   {
      [coder decodeValueOfObjCType:@encode( id)
                                at:p];
      [coder decodeValueOfObjCType:@encode( id)
                                at:q];
      ++p;
      ++q;
   }

   // ugliness
   [(id <_MulleObjCDictionary>) self  _setObjects:values
                                             keys:keys
                                            count:count];

   MulleObjCMakeObjectsPerformRelease( keys, count * 2);
   MulleObjCObjectDeallocateMemory( self, keys);
}


- (void) encodeWithCoder:(NSCoder *) coder
{
   NSUInteger     count;
   NSEnumerator   *rover;
   id             key;
   id             value;

   count = (NSUInteger) [self count];
   [coder encodeValueOfObjCType:@encode( NSUInteger)
                             at:&count];

   rover = [self keyEnumerator];
   while( key = [rover nextObject])
   {
      value = [self objectForKey:key];
      [coder encodeObject:key];
      [coder encodeObject:value];
   }
}

@end


@implementation NSMutableDictionary( NSCoder)

- (Class) classForCoder
{
   return( [NSMutableDictionary class]);
}

@end

