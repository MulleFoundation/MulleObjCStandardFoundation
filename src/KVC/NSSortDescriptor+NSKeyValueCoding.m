//
//  NSSortDescriptor+NSKeyValueCoding.m
//  MulleObjCFoundation
//
//  Created by Nat! on 28.03.17.
//  Copyright © 2017 Mulle kybernetiK. All rights reserved.
//

#import "MulleObjCFoundationContainer.h"

// other files in this library
#import "NSObject+KeyValueCoding.h"

// other libraries of MulleObjCFoundation

// std-c and other dependencies


@implementation NSSortDescriptor (NSKeyValueCoding)

- (NSComparisonResult) compareObject:(id) a
                            toObject:(id) b
{
   NSComparisonResult   result;
   id    aValue;
   id    bValue;

   aValue = [a valueForKeyPath:_key];
   bValue = [b valueForKeyPath:_key];

   if( aValue == bValue)
      return( NSOrderedSame);

   result = (NSComparisonResult) [aValue performSelector:_selector
                                              withObject:bValue];
   return( _ascending ? result : -result);
}

@end
