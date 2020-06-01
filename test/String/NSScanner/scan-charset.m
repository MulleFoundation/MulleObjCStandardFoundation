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
   NSCharacterSet    *sets[] =
   {
      [NSCharacterSet decimalDigitCharacterSet],
      [NSCharacterSet letterCharacterSet]
   };
   char    *setNames[] =
   {
      "decimalDigitCharacterSet",
      "letterCharacterSet"
   };
   NSCharacterSet    *set;
   NSScanner         *scanner;
   NSString          *string;
   NSString          *s1;
   NSString          *s2;
   int               i;
   int               j;
   char              *s;
   char              *sep;

   for( i = 0; i < sizeof( sets) / sizeof( sets[ 0]); i++)
   {
      set = sets[ i];
      printf( "%s (skip white: %s)\n", setNames[ i], flag ? "NO" : "YES");

      for( j = 0; j < sizeof( strings) / sizeof( strings[ 0]); j++)
      {
         string = strings[ j];
         sep    = "";
         printf( "\tScanning \"%s\" :: ", [string UTF8String]);
         scanner = [NSScanner scannerWithString:string];
         if( flag)
            [scanner setCharactersToBeSkipped:nil];

         while( ! [scanner isAtEnd])
         {
            [scanner scanCharactersFromSet:set
                                intoString:&s1];
            [scanner scanUpToCharactersFromSet:set
                                     intoString:&s2];
            printf( "%sscanSet:\"%s\" scanNotInSet:\"%s\"", sep, [s1 UTF8String], [s2 UTF8String]);
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

