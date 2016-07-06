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
   NSDictionary   *dict;
   NSNumber       *nr;
   NSString       *key;

   // simple basic test for leakage and key equality
   nr   = [NSNumber numberWithInt:1848];
   key  = [NSString stringWithUTF8String:"bar"];

   dict = [NSMutableDictionary dictionary];
   [dict setObject:nr
            forKey:key];
   key = [NSString stringWithUTF8String:"bar"];

   printf( "%s\n", [dict objectForKey:key] == nr ? "passed" : "failed");

   return( 0);
}
