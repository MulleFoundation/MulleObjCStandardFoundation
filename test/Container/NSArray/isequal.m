//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>


int main(int argc, const char * argv[])
{
   BOOL      passed;
   NSArray  *a;
   NSArray  *b;

   a = @[ @"a", @"b", @"c"];
   b = @[ @"a", @"b", @"c", @"d"];
   passed = ! [a isEqualToArray:b];
   printf( "%s\n", passed ? "passed" : "failed");

   return( 0);
}
