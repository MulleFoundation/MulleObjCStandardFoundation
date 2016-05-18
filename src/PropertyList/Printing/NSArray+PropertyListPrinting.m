/*
 *  NSArray+PropertyListPrinting.m
 *  MulleObjCEOUtil
 *  $Id$ 
 *  Created by Nat! on 10.08.09.
 *  Copyright 2009 MulleObjC kybernetiK. All rights reserved.
 *
 *  $Log$
 *
 */
#import "NSArray+PropertyListPrinting.h"

// other files in this library

// other libraries of MulleObjCFoundation

// std-c and dependencies


@implementation NSArray ( PropertyListPrinting)


static char   separator[] = { ',', ' ' };
static char   opener[]    = { '(', ' ' };
static char   closer[]    = { ' ', ')' };
//static char   empty[]     = { '(', ')' };


- (void) propertyListUTF8DataToStream:(id <_MulleObjCOutputDataStream>) handle
                               indent:(unsigned int) indent
{
   NSUInteger   i, n;
   id           value;
   unsigned     indent1;
   
   n = [self count];
   if( ! n)
   {
      [handle writeBytes:separator
                  length:sizeof( separator)];
      return;
   }
   
   [handle writeBytes:opener
               length:sizeof( opener)];
   
   indent1 = indent + 1;
  
   for( i = 0; i < n; i++)
   {
      if( i)
         [handle writeBytes:separator
                     length:sizeof( separator)];
      value = [self objectAtIndex:i];
      [value propertyListUTF8DataToStream:handle
                                   indent:indent1];
   }

   [handle writeBytes:closer
               length:sizeof( closer)];
}

@end
