//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  test( NSString *s, NSString *fix)
{
   printf( "\"%s\" has suffix \"%s\": %s\n", 
            [s UTF8String],
            [fix UTF8String],
            [s hasSuffix:fix] ? "YES" : "NO");
   printf( "\"%s\" has prefix \"%s\": %s\n", 
            [s UTF8String],
            [fix UTF8String],
            [s hasPrefix:fix] ? "YES" : "NO");
}


int main( int argc, const char * argv[])
{
   test( @"", @"0");
   test( @" ", @"0");
   test( @"0", @"0");
   test( @"10", @"0");
   test( @"01", @"0");

   return( 0);
}
