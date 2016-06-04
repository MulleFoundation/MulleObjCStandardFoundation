/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  NSMutableDictionary+KeyValueCoding.m is a part of MulleFoundation
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



@implementation NSMutableDictionary( _KeyValueCoding)

- (void) takeValue:(id) value
            forKey:(NSString *) key
{
   if( ! value)
   {
      [self removeObjectForKey:key];
      return;
   }
   [self setObject:value
            forKey:key];
}

@end
