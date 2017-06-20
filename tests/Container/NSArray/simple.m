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
   NSArray        *array;
   NSNumber       *nr;
   NSString       *key;

   // simple basic test for leakage

   nr    = [NSNumber numberWithInt:1848];
   key   = [NSString stringWithUTF8String:"bar"];
   array = [NSArray arrayWithObjects:nr, key, nil];

   printf( "%s\n", [array count] == 2 ? "passed" : "failed");

   return( 0);
}
