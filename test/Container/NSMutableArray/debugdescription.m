//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main( int argc, const char * argv[])
{
   NSMutableArray   *array;
   NSNumber         *nr;
   NSString         *key;
   NSString         *address;
   NSString         *desc;

   // simple basic test for leakage

   nr    = [NSNumber numberWithInteger:1848]; // too big for tps ?
   array = [NSMutableArray arrayWithObject:nr];
   key   = [NSString stringWithUTF8String:"not-a-tps-pointer"];
   [array addObject:key];

   address = [NSString stringWithFormat:@"%p", array];
   desc    = [array debugDescription];
   desc    = [desc stringByReplacingOccurrencesOfString:address
                                             withString:@"<address>"];
   address = [NSString stringWithFormat:@"%p", key];
   desc    = [desc stringByReplacingOccurrencesOfString:address
                                             withString:@"<address>"];
   address = [NSString stringWithFormat:@"%p", nr];
   desc    = [desc stringByReplacingOccurrencesOfString:address
                                             withString:@"<address>"];
   printf( "%s\n", [desc UTF8String]);

   return( 0);
}
