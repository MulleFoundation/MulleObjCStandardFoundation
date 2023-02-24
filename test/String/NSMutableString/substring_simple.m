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
   NSString            *other;

   s = [NSMutableString stringWithString:@"VfL Bochum 1848"];

   other = [s substringWithRange:NSMakeRange( 0, 0)];
   printf( "%s\n", [other UTF8String]);

   other = [s substringWithRange:NSMakeRange( 4, 6)];
   printf( "%s\n", [other UTF8String]);

   return( 0);
}
