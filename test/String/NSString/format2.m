//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


//
// this caught a bug in mulle_buffer
//
int main( int argc, const char * argv[])
{
   NSString   *s;
   NSString   *big;
   NSString   *emoji;

   big   = @"Lorem ipsum dolor sit amet, consectetur adipisici elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquid ex ea commodi consequat. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.";
   emoji = [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease];

   s = [NSString stringWithFormat:@"%@ %@ %@ %@",
      big, emoji, big, emoji];
   printf( "%s\n", [s UTF8String]);

   return( 0);
}
