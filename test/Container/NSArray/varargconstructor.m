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
   NSArray        *array;

   array = [NSArray arrayWithObjects:nil];
   printf( "%s\n", array && [array count] == 0 ? "passed" : "failed");

   array = [NSArray arrayWithObjects:@"foo", nil];
   printf( "%s\n", [array count] == 1 ? "passed" : "failed");

   array = [NSArray arrayWithObjects:@"foo", @"bar", nil];
   printf( "%s\n", [array count] == 2 ? "passed" : "failed");

   return( 0);
}
