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
   void        *nr;
   void        *key;

   key  = (void *) 18;
   nr   = (void *) 48;

   table = NSCreateMapTable( NSIntegerMapKeyCallBacks, NSIntegerMapValueCallBacks, 16);

   mulle_printf( "%s\n", NSCountMapTable( table) == 0 ? "passed" : "failed");
   mulle_printf( "%s\n", NSMapGet( table, key) == nil ? "passed" : "failed");

   // simple basic test for leakage and key equality

   NSMapInsert( table, key, nr);

   mulle_printf( "%s\n", NSMapGet( table, key) == nr ? "passed" : "failed");
   mulle_printf( "%s\n", NSCountMapTable( table) == 1 ? "passed" : "failed");

   NSMapRemove( table, nr);
   mulle_printf( "%s\n", NSCountMapTable( table) == 1 ? "passed" : "failed");

   NSMapRemove( table, key);
   mulle_printf( "%s\n", NSCountMapTable( table) == 0 ? "passed" : "failed");


   NSFreeMapTable( table);

   return( 0);
}
