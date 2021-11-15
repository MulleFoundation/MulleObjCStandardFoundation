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


void  test( BOOL flag)
{
   NSString    *strings[] =
   {
      @"1848",
      @" 18 48 ",
      @"11a2bb",
      @""
   };
   NSString    *searchStrings[] =
   {
     @"1",
     @"18",
     @"184",
     @"1848",
     @""
   };
   NSScanner         *scanner;
   NSString          *search;
   NSString          *string;
   NSString          *s1;
   NSString          *s2;
   int               i;
   int               j;
   char              *s;
   char              *sep;

   for( i = 0; i < sizeof( searchStrings) / sizeof( searchStrings[ 0]); i++)
   {
      search = searchStrings[ i];
      printf( "Search for %s (skip white: %s)\n", [search UTF8String], flag ? "NO" : "YES");

      for( j = 0; j < sizeof( strings) / sizeof( strings[ 0]); j++)
      {
         string = strings[ j];
         sep    = "";
         printf( "\tScanning \"%s\" :: ", [string UTF8String]);
         fflush( stdout);

         scanner = [NSScanner scannerWithString:string];
         if( flag)
            [scanner setCharactersToBeSkipped:nil];

         while( ! [scanner isAtEnd])
         {
            [scanner scanString:search
                     intoString:&s1];
            [scanner scanUpToString:search
                        intoString:&s2];
            printf( "%sscanString:\"%s\" scanUptoString:\"%s\"", sep, [s1 UTF8String], [s2 UTF8String]);
            fflush( stdout);
            sep =", ";
         }
         printf( "\n");
      }
   }
}


int main( int argc, const char * argv[])
{
   test( YES);
   test( NO);
   return( 0);
}

