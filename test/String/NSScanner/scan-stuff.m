//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"

#include <stdio.h>


static void  test( void)
{
   NSScanner         *scanner;
   NSString          *s;
   NSCharacterSet    *whitespace;
   char              *sep;
   int               i;

   scanner    = [NSScanner scannerWithString:@" xyz yzx zyx"];
   whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
   [scanner setCharactersToBeSkipped:whitespace];

   for( sep = "", i = 0; ! [scanner isAtEnd]; sep =", ", i++)
   {
      s = nil;
      if( [scanner scanString:@"xyz"
                   intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         continue;
      }
      if( [scanner scanString:@"yzx"
                   intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         continue;
      }
      if( [scanner scanString:@"zyx"
                   intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         continue;
      }
      abort();
   }
   printf( "\n");
}


int main( int argc, const char * argv[])
{
   test();
   return( 0);
}

