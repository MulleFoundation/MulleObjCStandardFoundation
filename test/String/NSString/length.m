//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void   print_length( NSString *a)
{
   if( a)
      printf( "\"%s\": %lu\n", [a UTF8String], (unsigned long) [a length]);
   else
      printf( "*nil*: %lu\n", (unsigned long) [a length]);
}


int main( int argc, const char * argv[])
{
   NSMutableString  *s;

   print_length( nil);
   print_length( @"");
   print_length( @"A");
   print_length( @"1848");
   print_length( [NSString stringWithUTF8String:"1848"]);
   print_length( @"VfL 1848");
   print_length( @"VfL Bochum 1848");

   print_length( [[@"1848" mutableCopy] autorelease]);
   print_length( [[@"VfL Bochum 1848" mutableCopy] autorelease]);

   s = [[@"VfL" mutableCopy] autorelease];
   [s appendString:@" 1848"];

   print_length( s);

   return( 0);
}
