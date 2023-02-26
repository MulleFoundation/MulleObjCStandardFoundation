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

   scanner    = [NSScanner scannerWithString:@"xxyyzzy"];
   whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
   [scanner setCharactersToBeSkipped:whitespace];

   for( sep = "", i = 0; ! [scanner isAtEnd]; sep =", ", i++)
   {
      s = nil;
      if( [scanner mulleScanUpToAndIncludingString:@"x"  // x x
                                        intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         fflush( stdout);
         continue;
      }
      if( [scanner mulleScanUpToAndIncludingString:@"yy"
                                        intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         fflush( stdout);
         continue;
      }
      if( [scanner mulleScanUpToAndIncludingString:@"zzy"
                                        intoString:&s])
      {
         mulle_printf( "%s#(%d)=%@", sep, i, s);
         fflush( stdout);
         continue;
      }
      mulle_printf( "\nfail: \"%@\"\n", [scanner mulleUnscannedString]);
      break;
   }
   printf( "\n");
}


int main( int argc, const char * argv[])
{
   test();
   return( 0);
}

