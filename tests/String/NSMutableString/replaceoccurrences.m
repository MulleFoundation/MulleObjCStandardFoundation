//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleStandaloneObjCFoundation/MulleStandaloneObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"

int   main(int argc, const char * argv[])
{
   NSMutableString     *s;

   s = [NSMutableString stringWithString:@"\n"];
   [s replaceOccurrencesOfString:@"\n"
                      withString:@"\\n"
                         options:NSLiteralSearch
                           range:NSMakeRange( 0, [s length])];
   printf( "%s\n", [s UTF8String]);

   s = [NSMutableString stringWithString:@"\\n"];
   [s replaceOccurrencesOfString:@"\n"
                      withString:@"\\n"
                         options:NSLiteralSearch
                           range:NSMakeRange( 0, [s length])];
   printf( "%s\n", [s UTF8String]);

   s = [NSMutableString stringWithString:@"\\\n"];
   [s replaceOccurrencesOfString:@"\n"
                      withString:@"\\n"
                         options:NSLiteralSearch
                           range:NSMakeRange( 0, [s length])];
   printf( "%s\n", [s UTF8String]);

   s = [NSMutableString string];
   [s replaceOccurrencesOfString:@"\n"
                      withString:@"\\n"
                         options:NSLiteralSearch
                           range:NSMakeRange( 0, [s length])];
   printf( "%s\n", [s UTF8String]);

   return( 0);
}
