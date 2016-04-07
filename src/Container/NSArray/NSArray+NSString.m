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

//#import "NSMutableString.h"


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

   if( [self count] <= 1)
      return( [self lastObject]);
      
   buffer = nil;
   rover  = [self objectEnumerator];

   selNext = @selector( nextObject);
   impNext = [rover methodForSelector:selNext];
   
   while( s = (*impNext)( rover, selNext, NULL))
   {
      if( ! buffer)
      {
         buffer    = [NSMutableString string];
         selAppend = @selector( appendString:);
         impAppend = [buffer methodForSelector:selAppend];
      }
      else
         (*impAppend)( buffer, selAppend, separator);
      
      (*impAppend)( buffer, selAppend, s);
   }
   return( buffer);
}


- (id) description
{
   NSMutableString   *s;
   
   s = [NSMutableString string];
   [s appendString:@"("];
   [s appendString:[self componentsJoinedByString:@", "]];
   [s appendString:@")"];
   return( s);
}

@end
