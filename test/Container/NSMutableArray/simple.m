//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{
   NSMutableArray   *array;
   NSNumber         *nr;
   NSString         *key;

   // simple basic test for leakage

   nr    = [NSNumber numberWithInt:1848];
   array = [NSMutableArray arrayWithObject:nr];
   key   = [NSString stringWithUTF8String:"bar"];
   [array addObject:key];

   printf( "%s\n", [array count] == 2 ? "passed" : "failed");

   @try
   {
     [array addObject:nil];
     return( 1);
   }
   @catch( NSException *e)
   {
      printf( "%s\n", [[e name] UTF8String]);
   }

   return( 0);
}
