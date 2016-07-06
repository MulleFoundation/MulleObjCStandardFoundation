//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCFoundation/MulleObjCFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  print_range( NSRange range)
{
   if( range.location == NSNotFound && range.length == 0)
      printf( "{ NSNotFound, 0 }\n");
   else
      printf( "{ %lu, %lu }\n", (long) range.location, (long) range.length);
}


int main(int argc, const char * argv[])
{
   NSMutableString     *s;
   NSRange             range;

   s = [NSMutableString string];

   [s appendString:@"VfL"];
   [s appendString:@" "];
   [s appendString:@"Bochum"];
   [s appendString:@" "];
   [s appendString:@"1848"];

   range = [s rangeOfString:@"L Bo"];
   print_range( range);

   range = [s rangeOfString:@"1848"];
   print_range( range);

   range = [s rangeOfString:@"VfL"];
   print_range( range);

   range = [s rangeOfString:@"BOCHUM"];
   print_range( range);

   range = [s rangeOfString:@"BOCHUM"
                    options:NSCaseInsensitiveSearch];
   print_range( range);

   return( 0);
}
