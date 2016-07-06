//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>


int main(int argc, const char * argv[])
{
   NSMapTable  *table;
   NSNumber    *nr;
   NSString    *key;

   table = NSCreateMapTable( NSObjectMapKeyCallBacks, NSObjectMapValueCallBacks, 16);

   // simple basic test for leakage and key equality
   nr   = [NSNumber numberWithInt:1848];
   key  = [NSString stringWithUTF8String:"bar"];

   NSMapInsert( table, key, nr);
   key = [NSString stringWithUTF8String:"bar"];

   printf( "%s\n", NSMapGet( table, key) == nr ? "passed" : "failed");

   NSFreeMapTable( table);

   return( 0);
}
