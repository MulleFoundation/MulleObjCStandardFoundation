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
   NSArray  *obj;
   NSString  *a;
   NSString  *b;

   obj = [NSArray alloc];
   a   = @"%@ %@ %@ %@ %@";
   b   = @"1";
   obj = [obj initWithObjects:a, b, nil];
   [obj autorelease];
   printf( "%s\n", [obj UTF8String]);
   return( 0);
}
