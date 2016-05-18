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
#import "NSEnumerator.h"

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


BOOL   NSArrayCompatibleDescription = YES;

- (NSString *) _descriptionWithSelector:(SEL) sel
{
   NSMutableString   *s;
   NSEnumerator      *rover;
   BOOL              flag;
   id                p;
   NSString          *initalSpaceOne;
   NSString          *initalSpaceMany;
   NSString          *secondSpace;
   NSString          *firstNewLine;
   NSUInteger        count;
   
   count = [self count];
   if( ! count)
      return( NSArrayCompatibleDescription ? @"(\n)" : @"()");

   if( NSArrayCompatibleDescription)
   {
      initalSpaceOne  = @"\n    ";
      initalSpaceMany = @"\n";
      secondSpace     = @"    ";
      firstNewLine    = @"\n";
   }
   else
   {
      initalSpaceOne  = @" ";
      initalSpaceMany = @"\n";
      secondSpace     = @"   ";
      firstNewLine    = @" ";
   }

   flag  = NO;
   s     = [NSMutableString stringWithString:@"("];
   if( count > 1)
      [s appendString:initalSpaceMany];
   else
      [s appendString:initalSpaceOne];

   rover = [self objectEnumerator];
   while( p = [rover nextObject])
   {
      if( flag)
         [s appendString:@",\n"];
      flag = YES;

      if( count > 1)
         [s appendString:secondSpace];

      [s appendString:[p performSelector:sel]];
   }

   if( count == 1)
      [s appendString:firstNewLine];
   else
      [s appendString:@"\n"];

   [s appendString:@")"];

   return( s);
}


- (NSString *) description
{
   return( [self _descriptionWithSelector:_cmd]);
}


- (NSString *) _debugContentsDescription
{
   return( [self _descriptionWithSelector:_cmd]);
}


@end
