//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


int main(int argc, const char * argv[])
{
   NSMutableString     *s;
   NSString            *copy;
   NSMutableString     *clone;

   s = [NSMutableString string];
   mulle_printf( "%td\n", (ptrdiff_t) [s length]);

   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];
   mulle_printf( "%td\n", (ptrdiff_t) [s length]);

   copy  = [NSString stringWithString:s];
   mulle_printf( "%td\n", (ptrdiff_t) [copy length]);

   clone = [NSMutableString stringWithString:copy];
   mulle_printf( "%td\n", (ptrdiff_t) [clone length]);

   if( [s hash] == [clone hash] && [s isEqualToString:clone])
      mulle_printf( "%s\n", [clone UTF8String]);

   return( 0);
}
