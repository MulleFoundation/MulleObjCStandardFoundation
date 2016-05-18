//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>


int main(int argc, const char * argv[])
{
   NSArray        *array;
   NSArray        *other;
   NSNumber       *nr;
   NSString       *key;
   NSEnumerator   *rover;

   // simple basic test for leakage

   nr    = [NSNumber numberWithInt:1848];
   key   = [NSString stringWithUTF8String:"bar"];
   array = [NSArray arrayWithObjects:nr, key, nil];
   rover = [array objectEnumerator];
   other = [rover allObjects];

   printf( "%s\n", array != other && [array isEqual:other] ? "passed" : "failed");

   return( 0);
}
