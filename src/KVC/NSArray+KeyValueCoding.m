/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSArray+KeyValueCoding.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK 
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSObject+KeyValueCoding.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationContainer.h"
#import "MulleObjCFoundationException.h"
#import "MulleObjCFoundationString.h"
#import "MulleObjCFoundationValue.h"

// std-c and other dependencies


@implementation NSArray( _KeyValueCoding)

- (id) valueForKey:(NSString *) key
{
   NSMutableArray   *array;
   void             *(*get)();
   void             (*append)();
   NSUInteger       i, n;
   id               p;
   id               value;
   
   NSCParameterAssert( [key isKindOfClass:[NSString class]]);
   
   if( [key hasPrefix:@"@"])
      return( [super valueForKey:key]);
   
   n = [self count];
   if( ! n)
      return( self);  // i am empty
   
   array  = [NSMutableArray arrayWithCapacity:n];
   
   get    = (void *) [self methodForSelector:@selector( objectAtIndex:)];
   append = (void *) [array methodForSelector:@selector( addObject:)];
   
   for( i = 0; i < n; i++)
   {
      p     = (id) (*get)( self, @selector( objectAtIndex:), i);
      value = [p valueForKeyPath:key]; 
      if( ! value)
         value = [NSNull null];
      (*append)( array, @selector( addObject:), value);
   }
   
   return( array);
}

@end
