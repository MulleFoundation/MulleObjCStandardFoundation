/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSArray+NSString.m is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#import "NSArray+NSString.h"

// other files in this library

// other libraries of MulleObjCFoundation
#import "MulleObjCFoundationString.h"

// std-c and dependencies


@implementation NSArray( NSString)

- (NSString *) componentsJoinedByString:(NSString *) separator
{
   NSEnumerator      *rover;
   SEL               selNext;
   IMP               impNext;
   SEL               selAppend;
   IMP               impAppend;
   NSMutableString   *buffer;
   NSString          *s;
   NSUInteger        count;
   
   switch( [self count])
   {
   case 0 : return( @"");
   case 1 : return( [self lastObject]);
   }
   
   buffer    = [NSMutableString string];
   selAppend = @selector( appendString:);
   impAppend = [buffer methodForSelector:selAppend];

   rover  = [self objectEnumerator];
   selNext = @selector( nextObject);
   impNext = [rover methodForSelector:selNext];

   s = (*impNext)( rover, selNext, NULL);
   (*impAppend)( buffer, selAppend, s);
   
   while( s = (*impNext)( rover, selNext, NULL))
   {
      (*impAppend)( buffer, selAppend, separator);
      (*impAppend)( buffer, selAppend, s);
   }
   return( buffer);
}


- (id) description
{
   NSMutableString   *s;
   NSEnumerator      *rover;
   BOOL              flag;
   id                p;
   
   flag = NO;
   s = [NSMutableString stringWithString:@"("];
   rover = [self objectEnumerator];
   while( p = [rover nextObject])
   {
      if( flag)
         [s appendString:@", "];
      flag = YES;
      
      [s appendString:[p description]];
   }
   [s appendString:@")"];
   return( s);
}


- (id) debugDescription
{
   NSMutableString   *s;
   NSEnumerator      *rover;
   BOOL              flag;
   id                p;
   
   flag = NO;
   s = [NSMutableString stringWithString:@"("];
   rover = [self objectEnumerator];
   while( p = [rover nextObject])
   {
      if( flag)
         [s appendString:@", "];
      flag = YES;
      
      [s appendString:[p debugDescription]];
   }
   [s appendString:@")"];
   return( s);
}

@end
