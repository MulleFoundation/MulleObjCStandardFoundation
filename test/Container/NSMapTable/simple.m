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
   NSMapTable  *table;
   NSNumber    *nr;
   NSString    *key;

   key  = [NSString stringWithUTF8String:"bar"];
   nr   = [NSNumber numberWithInt:1848];

   table = NSCreateMapTable( NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 16);

   printf( "%s\n", NSCountMapTable( table) == 0 ? "passed" : "failed");
   printf( "%s\n", NSMapGet( table, key) == nil ? "passed" : "failed");

   // simple basic test for leakage and key equality

   NSMapInsert( table, key, nr);
   key = [NSString stringWithUTF8String:"bar"];

   printf( "%s\n", NSMapGet( table, key) == nr ? "passed" : "failed");
   printf( "%s\n", NSCountMapTable( table) == 1 ? "passed" : "failed");

   NSMapRemove( table, nr);
   printf( "%s\n", NSCountMapTable( table) == 1 ? "passed" : "failed");

   NSMapRemove( table, key);
   printf( "%s\n", NSCountMapTable( table) == 0 ? "passed" : "failed");

   // reinsert for leak detection
   NSMapInsert( table, key, nr);

   NSFreeMapTable( table);

   return( 0);
}
