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
   NSString            *other;
   NSMutableString     *clone;

   s = [NSMutableString string];

   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];

   other = [s substringWithRange:NSMakeRange( 2, 10)];
   printf( "%s\n", [other UTF8String]);

   other = [s substringWithRange:NSMakeRange( 0, 0)];
   printf( "%s\n", [other UTF8String]);

   return( 0);
}
