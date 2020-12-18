//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
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
   [s appendString:@"VfL 1848"];

   range = [s rangeOfString:@"L Bo"
                    options:NSBackwardsSearch];
   print_range( range);

   range = [s rangeOfString:@"1848"
                    options:NSBackwardsSearch];
   print_range( range);

   range = [s rangeOfString:@"VfL"
                    options:NSBackwardsSearch];
   print_range( range);

   range = [s rangeOfString:@"BOCHUM"
                    options:NSBackwardsSearch];
   print_range( range);

   range = [s rangeOfString:@"BOCHUM"
                    options:NSBackwardsSearch|NSCaseInsensitiveSearch];
   print_range( range);

   return( 0);
}
