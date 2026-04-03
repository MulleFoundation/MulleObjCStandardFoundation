//
//  main.m
//  archiver-test
//
//  Created by Nat! on 19.04.16.
//  Copyright © 2016 Mulle kybernetiK. All rights reserved.
//


#import <MulleObjCStandardFoundation/MulleObjCStandardFoundation.h>
//#import "MulleStandaloneObjCFoundation.h"


static void  print_comparison( NSComparisonResult  result)
{
   switch( result)
   {
   case NSOrderedSame       : mulle_printf( "same\n"); break;
   case NSOrderedAscending  : mulle_printf( "ascending\n"); break;
   case NSOrderedDescending : mulle_printf( "descending\n"); break;
   default                  : mulle_printf( "???\n"); break;
   }
}


int main( int argc, const char * argv[])
{
   print_comparison( [@"VfL" compare:@"VfL"]);
   print_comparison( [@"vfL" compare:@"VfL"]);
   print_comparison( [@"VfL" compare:@"vfL"]);
   print_comparison( [@"VFL" compare:@"VfL"]);

   mulle_printf( "--\n");
   print_comparison( [@"VfL" caseInsensitiveCompare:@"VfL"]);
   print_comparison( [@"vfL" caseInsensitiveCompare:@"VfL"]);
   print_comparison( [@"VfL" caseInsensitiveCompare:@"vfL"]);
   print_comparison( [@"VFL" caseInsensitiveCompare:@"VfL"]);

   print_comparison( [@"VfL" caseInsensitiveCompare:@"VfB"]);
   print_comparison( [@"VfB" caseInsensitiveCompare:@"VfL"]);

   return( 0);
}
