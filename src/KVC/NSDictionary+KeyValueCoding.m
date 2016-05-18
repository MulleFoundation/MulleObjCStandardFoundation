/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSDictionary+KeyValueCoding.m is a part of MulleFoundation
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
#import "MulleObjCFoundationString.h"

// std-c and other dependencies



@implementation NSDictionary( _KeyValueCoding)

- (id) valueForKey:(NSString *) key
{
   NSUInteger   length;
   
   length = [key length];
   if( ! length)
      return( nil);  // strange but compatible!

   return( [self objectForKey:key]);
}

@end
