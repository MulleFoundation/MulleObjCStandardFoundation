//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int main(int argc, const char * argv[])
{
   NSMutableString     *s;
   NSString            *copy;
   NSMutableString     *clone;

   s = [NSMutableString string];
   printf( "%ld\n", [s length]);

   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];
   printf( "%ld\n", [s length]);

   copy  = [[s copy] autorelease];
   printf( "%ld\n", [copy length]);

   clone = [[copy mutableCopy] autorelease];
   printf( "%ld\n", [clone length]);

   if( [s hash] == [clone hash] && [s isEqualToString:clone])
      printf( "%s\n", [clone UTF8String]);

   return( 0);
}
