//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int main( int argc, const char * argv[])
{
   NSMutableString     *s;
    NSString            *emojis;

   emojis = [[[NSString alloc] initWithBytes:"\xe2\x98\x84\xef\xb8\x8f\xe2\x98\x83\xef\xb8\x8f\xf0\x9f\x91\x8d\xf0\x9f\x8f\xbe" /* emoji comet, snowman, thumbs-up brown */ length:20 encoding:NSUTF8StringEncoding] autorelease];

   s = [NSMutableString object];
   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];
   [s appendString:emojis];

   printf( "%s\n", [s UTF8String]);

   return( 0);
}
