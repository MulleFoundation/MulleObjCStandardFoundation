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
   NSDictionary   *dict;
   NSNumber       *nr;
   NSString       *key;

   // simple basic test for leakage really
   nr   = [NSNumber numberWithInt:1848];
   key  = [NSString stringWithUTF8String:"bar"];
   dict = @{ key: nr };

   printf( "%s\n", [dict objectForKey:key] == nr ? "passed" : "failed");

   return( 0);
}
