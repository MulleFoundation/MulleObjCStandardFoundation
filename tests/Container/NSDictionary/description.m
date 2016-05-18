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
   NSDictionary   *dict;
   NSNumber       *nr;
   NSString       *key;

   // simple basic test for leakage and key equality
   nr   = [NSNumber numberWithInt:1848];
   key  = [NSString stringWithUTF8String:"bar"];
   dict = [NSDictionary dictionaryWithObject:nr
                                      forKey:key];

   printf( "%s\n", [[dict description] UTF8String]);

   return( 0);
}
